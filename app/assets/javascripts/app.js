/*
 * Copyright (c) 2014 DataTorrent, Inc. ALL Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';
(function(angular) {
    var myApp = angular.module('myApp', ['ui.dashboard', 'googlechart']);

    myApp.factory('widgetDefinitions', function() {
        return [{
            name: 'sales',
            directive: 'geo-sales',
            style: {
                width: '50%'
            }

        }, {
            name: 'employees',
            directive: 'geo-workers',
            style: {
                width: '50%'
            }
        }];
    });
    myApp.value('defaultWidgets', [{
            name: 'sales',
            style: {
                width: '50%'
            }
        }, {
            name: 'employees',
            style: {
                width: '50%'
            }
        }

    ]);
    myApp.controller('DashCtrl', ["$scope", "$window", "widgetDefinitions", "defaultWidgets", function($scope, $window, widgetDefinitions, defaultWidgets) {

        $scope.dashboardOptions = {
            widgetButtons: true,
            widgetDefinitions: widgetDefinitions,
            defaultWidgets: defaultWidgets,
            storage: $window.localStorage,
            storageId: 'demo'
        };

    }]);
    myApp.directive('geoWorkers', ["$http", "GeoMap", function($http, GeoMap) {
        return {
            restrict: 'A',
            scope: true,
            replace: true,
            template: '<div><div class="spinner-loader" ng-show="loading"></div>Employee Location<div google-chart chart="chart"></div></div>',
            link: function(scope) {
                //
                // wanted a factory for api request but had issues with async
                // and assigning chart data that geomap uses to draw map
                // scope.loading used for loading spinner
                // 
                scope.loading = true;
                $http.get('api/employees').
                then(function(response) {
                    scope.chart = GeoMap.getGeoData(response.data, 'employees');
                    scope.loading = false;
                }, function(response) {
                    console.log("error getting geodata", response.data);
                });
            }
        };
    }]);
    myApp.directive('geoSales', ["$http", "GeoMap", function($http, GeoMap) {
        return {
            restrict: 'A',
            replace: true,
            template: '<div><div class="spinner-loader" ng-show="loading"></div>Sales<div google-chart chart="chart"></div></div>',
            //link: is a run once function that is envoked when widget is called
            link: function(scope) {
                scope.loading = true;
                $http.get('api/invoices').
                then(function(response) {
                    scope.chart = GeoMap.getGeoData(response.data, 'invoices');
                    scope.loading = false;
                }, function(response) {
                    console.log("error getting geodata", response.data);
                });

            }
        };
    }]);
    myApp.factory('GeoMap', function() {
        return {

            // getGeoData
            //
            // returns an object that is used by geomaps to create map
            // data: is an array of an array
            // eg. [ ["Country", "Count"], ["AU", 20], ["US", 20] ]
            // type: is a string used to determine paramaters for map
            // eg. "invoices"
            getGeoData: function(data, type) {

                var chart1 = {};
                chart1.type = "GeoChart";
                chart1.data = data;
                chart1.options = {
                    width: 500,
                    height: 300,
                    chartArea: {
                        left: 10,
                        top: 10,
                        bottom: 0,
                        height: "100%"
                    },
                    displayMode: 'regions'
                };

                if (type === "invoices") {
                    chart1.formatters = {
                        number: [{
                            columnNum: 1,
                            pattern: "$ #,##0.00"
                        }]
                    };
                    chart1.options = {
                        colorAxis: {
                            colors: ['#aec7e8', '#1f77b4']
                        }
                    };
                } else {
                    chart1.options = {
                        colorAxis: {
                            colors: ['#CDE081', '#0E9012']
                        }
                    };
                };

                return chart1
            }
        }
    });
})(angular);
