
    'use strict';
    var Geomap;

    describe('Service: GeoMap', function() {
        beforeEach( module('myApp') );

        // beforeEach(function() {
        //     module('myApp');
        //     inject(function($injector) {
        //         GeoMap = $injector.get('GeoMap');
        //     });
        // });

        it('returns JSON object with geochart data', inject(function(GeoMap) {
            var items;

            items = GeoMap.getGeoData([
                ["SPE", "HER"],
                ["AU", 20]
            ], "workers");
            expect(items.type).toEqual("GeoChar");
            expect(items.formatters).not.toBeDefined();
        }));

        it('returns JSON object according to geochart type', inject(function(GeoMap) {
            var items;

            items = GeoMap.getGeoData([
                ["SPE", "HER"],
                ["AU", 20]
            ], "invoices");
            expect(items.formatters).toBeDefined();
        }));
    });


