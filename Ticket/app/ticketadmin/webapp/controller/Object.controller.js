sap.ui.define([
    "./BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/ui/core/routing/History",
    "../model/formatter", 
	"sap/m/library",
    "sap/m/MessageBox",
], function (BaseController, JSONModel, History, formatter, mobileLibrary,MessageBox) {
    "use strict";
    var DialogType = mobileLibrary.DialogType;
    var ButtonType = mobileLibrary.ButtonType;
    return BaseController.extend("ticketadmin.controller.Object", {

        formatter: formatter,
        

        /* =========================================================== */
        /* lifecycle methods                                           */
        /* =========================================================== */

        /**
         * Called when the worklist controller is instantiated.
         * @public
         */
        onInit : function () {
            // Model used to manipulate control states. The chosen values make sure,
            // detail page shows busy indication immediately so there is no break in
            // between the busy indication for loading the view's meta data
            var oViewModel = new JSONModel({
                    busy : true,
                    delay : 0
                });
            this.getRouter().getRoute("object").attachPatternMatched(this._onObjectMatched, this);
            this.getView().setModel(oViewModel, "objectView");

            
        },
        /* =========================================================== */
        /* event handlers                                              */
        /* =========================================================== */


        /**
         * Event handler  for navigating back.
         * It there is a history entry we go one step back in the browser history
         * If not, it will replace the current entry of the browser history with the worklist route.
         * @public
         */
        onNavBack : function() {
            
            var sPreviousHash = History.getInstance().getPreviousHash();
            if (sPreviousHash !== undefined) {
                window.location.reload();
                // eslint-disable-next-line fiori-custom/sap-no-history-manipulation
                history.go(-1);
            } else {
                window.location.reload();
                this.getRouter().navTo("worklist", {}, true);
            }
        },

        /* =========================================================== */
        /* internal methods                                            */
        /* =========================================================== */

        /**
         * Binds the view to the object path.
         * @function
         * @param {sap.ui.base.Event} oEvent pattern match event in route 'object'
         * @private
         */
        _onObjectMatched: function (oEvent) {
            this._sObjectId =  oEvent.getParameter("arguments").objectId;
            console.log(this._sObjectId);
            this._bindView("/Tickets" + this._sObjectId);
        },

        /**
         * Binds the view to the object path.
         * @function
         * @param {string} sObjectPath path to the object to be bound
         * @private
         */
        _bindView : function (sObjectPath) {
            var oViewModel = this.getModel("objectView");

            this.getView().bindElement({
                path: sObjectPath,
                events: {
                    change: this._onBindingChange.bind(this),
                    dataRequested: function () {
                        oViewModel.setProperty("/busy", true);
                    },
                    dataReceived: function () {
                        oViewModel.setProperty("/busy", false);
                    }
                }
            });
        },

        _onBindingChange : function () {
            var oView = this.getView(),
                oViewModel = this.getModel("objectView"),
                oElementBinding = oView.getElementBinding();

            // No data for the binding
            if (!oElementBinding.getBoundContext()) {
                this.getRouter().getTargets().display("objectNotFound");
                return;
            }

            var oResourceBundle = this.getResourceBundle(),
                oObject = oView.getBindingContext().getObject(),
                sObjectId = oObject.ID,
                sObjectName = oObject.Tickets;

                oViewModel.setProperty("/busy", false);
                oViewModel.setProperty("/shareSendEmailSubject",
                    oResourceBundle.getText("shareSendEmailObjectSubject", [sObjectId]));
                oViewModel.setProperty("/shareSendEmailMessage",
                    oResourceBundle.getText("shareSendEmailObjectMessage", [sObjectName, sObjectId, location.href]));
        }, 

        navback: function () {
            
            history.go(-1);
		}, 

        onDelete : function () {
            var oData = this.getView().getModel("v2model")
            
            const id = this._sObjectId;
            console.log(id);
            
            MessageBox.confirm("Sure u want to delete this concept.", {
				actions: [MessageBox.Action.OK, MessageBox.Action.CANCEL],
				emphasizedAction: MessageBox.Action.OK,
				onClose: function (sAction) {
                    if(sAction === MessageBox.Action.OK ) {
                        oData.remove("/Tickets" + id +"",null,{
                            success: function (data) {	                                
                                window.location.reload();
                            },
                            error: function (error) {
                                MessageBox.error("Error while deleting the data");
                            }
                        });
                        	
                        history.go(-1);                     
                        
                    }
                    
                    
				}
			});
                     
        },
           
        create : function (){
            var oObj = {
				status: this.getView().byId("Status").getValue(),
				solution: this.getView().byId("Solution").getValue(),
			}

            console.log(oObj);
            
            const id = this._sObjectId;
            console.log(id);
            var oData = this.getView().getModel("v2model")

            oData.update("/Tickets" + id , oObj, {
				success: function (data) {
					window.location.reload();

				},
				error: function (error) {
					MessageBox.error("Error while creating the data");
				}
			});
			
            history.go(-1);
        }           
                       
                       
                        
                    
        

        
    });

});
