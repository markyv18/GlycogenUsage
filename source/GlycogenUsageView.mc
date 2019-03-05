using Toybox.WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;

class GlycogenUsageView extends WatchUi.SimpleDataField {

        // Constants
//        const CHO_BURN_FIELD_ID = 0;

        // Variables
//        hidden var CHO_Burn_Field;
          //pwf = per watt filler
        var pwf0_1 = 0.00;
        var pwf1_2 = 0.00;
        var pwf2_3 = 0.00;
        var pwf3_4 = 0.00;
        var pwf4_5 = 0.00;
        var pwf5_6 = 0.00;
        var pwf6_7 = 0.00;

        var pwr = 0;

        var watt_cho = {};

        var CHO_burn = 0.00;

        var counter = 0;

        var CHO_0 = 0.02;
        // CHO cals per second calculated as 300 g/day div 24 hrs div 60 min *4(CHO joules) div 60 then rounded up a tad for athlete metabolism
        var CHO_1 = 0;
        var CHO_2 = 0;
        var CHO_3 = 0;
        var CHO_4 = 0;
        var CHO_5 = 0;
        var CHO_6 = 0;
        var CHO_7 = 0;

        var WATT_0 = 0;
        var WATT_1 = 0;
        var WATT_2 = 0;
        var WATT_3 = 0;
        var WATT_4 = 0;
        var WATT_5 = 0;
        var WATT_6 = 0;
        var WATT_7 = 0;

    function initialize() {
        SimpleDataField.initialize();

        // importing values from mobile/desktop interface
        CHO_1 = App.getApp().getProperty("CHO_1").toFloat();
        WATT_1 = App.getApp().getProperty("WATT_1").toNumber();
        CHO_2 = App.getApp().getProperty("CHO_2").toFloat();
        WATT_2 = App.getApp().getProperty("WATT_2").toNumber();
        CHO_3 = App.getApp().getProperty("CHO_3").toFloat();
        WATT_3 = App.getApp().getProperty("WATT_3").toNumber();
        CHO_4 = App.getApp().getProperty("CHO_4").toFloat();
        WATT_4 = App.getApp().getProperty("WATT_4").toNumber();
        CHO_5 = App.getApp().getProperty("CHO_5").toFloat();
        WATT_5 = App.getApp().getProperty("WATT_5").toNumber();
        CHO_6 = App.getApp().getProperty("CHO_6").toFloat();
        WATT_6 = App.getApp().getProperty("WATT_6").toNumber();
        CHO_7 = App.getApp().getProperty("CHO_7").toFloat();
        WATT_7 = App.getApp().getProperty("WATT_7").toNumber();


// iteration 2: filter out null values here and build logic to only use the ones we have
// then offer 8 or 9 data points? never can have too few and will let the filtering take care of the too many

        //converting grams per minute to calories per second
        CHO_1 = (CHO_1 * 4 / 60);
        CHO_2 = (CHO_2 * 4 / 60);
        CHO_3 = (CHO_3 * 4 / 60);
        CHO_4 = (CHO_4 * 4 / 60);
        CHO_5 = (CHO_5 * 4 / 60);
        CHO_6 = (CHO_6 * 4 / 60);
        CHO_7 = (CHO_7 * 4 / 60);

        //Calculating the per watt calorie increments between each submitted value
        pwf0_1 = (CHO_1 - CHO_0) / (WATT_1 - WATT_0);
        pwf1_2 = (CHO_2 - CHO_1) / (WATT_2 - WATT_1);
        pwf2_3 = (CHO_3 - CHO_2) / (WATT_3 - WATT_2);
        pwf3_4 = (CHO_4 - CHO_3) / (WATT_4 - WATT_3);
        pwf4_5 = (CHO_5 - CHO_4) / (WATT_5 - WATT_4);
        pwf5_6 = (CHO_6 - CHO_5) / (WATT_6 - WATT_5);
        pwf6_7 = (CHO_7 - CHO_6) / (WATT_7 - WATT_6);


        // these loops build out the hash/dictionary that links a wattage value to a corresponding glycogen burn rate 0:.04, 1:.0456, 2:.0472... cal

        watt_cho.put(WATT_7, CHO_7);

        counter = (WATT_1 - WATT_0);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_0 + i), CHO_0 );
            CHO_0 = CHO_0 + pwf0_1;
            }

        counter = (WATT_2 - WATT_1);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_1 + i), CHO_1 );
            CHO_1 = CHO_1 + pwf1_2;
            }

        counter = (WATT_3 - WATT_2);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_2 + i), CHO_2 );
            CHO_2 = CHO_2 + pwf2_3;
            }

        counter = (WATT_4 - WATT_3);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_3 + i), CHO_3 );
            CHO_3 = CHO_3 + pwf3_4;
            }

        counter = (WATT_5 - WATT_4);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_4 + i), CHO_4 );
            CHO_4 = CHO_4 + pwf4_5;
            }

        counter = (WATT_6 - WATT_5);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_5 + i), CHO_5 );
            CHO_5 = CHO_5 + pwf5_6;
            }

        counter = (WATT_7 - WATT_6);

        for(var i = 0; i < counter; i ++)
            {
            watt_cho.put( (WATT_6 + i), CHO_6 );
            CHO_6 = CHO_6 + pwf6_7;
            }

        label = "Carb Cals";
    }

    function compute(info) {
        //Have we started?
        if (info.elapsedTime > 0) {
            // Is Power > 0, if not normalize to 0
            if (info.currentPower == null) {
                // Power data is null
                pwr = 0;
            }
            else if (info.currentPower < 0) {
                // Power data is below 0
                pwr = 0;
            }
            else if (info.currentPower > WATT_7) {
            	// Power data is above last known wattage hash key - above this most further contribution to power output comes from the reuse of lactate
				pwr = WATT_7;
            }
            else {
                // Incoming power data is OK! You've got the pow-wuh! https://www.youtube.com/watch?v=Cf_qfX9cKsQ Seriously, watch that, you're welcome.
                pwr = info.currentPower;
            }

        CHO_burn = CHO_burn + watt_cho.get(pwr);

        }

        else {
            // Initial display, before the the session is started
            return 0;
        }

		// For testing purposes in the simulator change 'info.currentPower to '(info.elapsedTime/1000)' this will mock wattage inputs

        return CHO_burn;
    }

}
