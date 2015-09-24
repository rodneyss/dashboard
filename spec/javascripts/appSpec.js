(function() {
    'use strict';

    describe('Service: GeoMap', function() {
        beforeEach(module('impac'));

        it('returns JSON object with geochart data', inject(function(GeoMap) {
            var items;

            items = GeoMap.getGeoData([
                ["SPE", "HER"],
                ["AU", 20]
            ], "workers");
            expect(items.type).toEqual("GeoChart");
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
})();
