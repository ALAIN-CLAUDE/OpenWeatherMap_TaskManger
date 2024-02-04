import LightningDatatable from "lightning/datatable";
import customPicklistStatus from "./customPicklistStatus.html";
import picklistStatic from './picklistStatic.html'

export default class CustomTypeGlobal extends LightningDatatable {
    static customTypes = {
        customPicklistStatus: {
          template:picklistStatic,
          editTemplate: customPicklistStatus,
          standardCellLayout: true,
          typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
      };
}