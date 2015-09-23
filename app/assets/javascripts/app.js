var impac = angular.module('impac', ['adf'])
  .config(function(dashboardProvider){
         
         dashboardProvider.structure('6-6', {
            rows: [{
              columns: [{
                styleClass: 'col-md-6',
                widgets: []
              }, {
                styleClass: 'col-md-6',
                widgets: []
              }]
            }]
          })
       });