sap.ui.define([
    "./BaseController",
	"sap/ui/core/date/UI5Date",
	"sap/ui/core/mvc/Controller",
	"sap/ui/model/json/JSONModel"
], function (BaseController,UI5Date, Controller, JSONModel) {
	"use strict";

	return BaseController.extend("ticket.controller.CreateForm", {


		onInit : function () {

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth()+1; //January is 0!
            var yyyy = today.getFullYear();
            var today1 = ( dd+'.'+mm+'.'+yyyy);
			var today2 = (yyyy+'-0'+mm+'-'+dd);
            this.getView().byId("date").setText(today1.valueOf(Text));

			
			var oTickey = {
				date : today2, 
				status : "New" 
			}
			var oModel = new JSONModel(oTickey);
			this.getView().setModel(oModel,"form");
            console.log(oTickey)
            
		},

        navback: function () {
			
            this.getRouter().navTo("worklist");
		},

		create : function (){
			var oForm = this.getView().getModel("form").getData();
			var oData = this.getView().getModel("v2model")

			oData.create("/Tickets", oForm, {
				success: function (data) {
					
					window.location.reload();

				},
				error: function (error) {
					MessageBox.error("Error while creating the data");
				}
			});


			this.getRouter().navTo("worklist");
			

		}
	});
});