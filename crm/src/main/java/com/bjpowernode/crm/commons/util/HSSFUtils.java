package com.bjpowernode.crm.commons.util;

import org.apache.poi.hssf.usermodel.HSSFCell;

/**
 * @author 栗舜顺
 * 2020/11/21 0021
 */
public class HSSFUtils {

    //将每列的返回值都换成String格式
    public static String getCellValueForStr(HSSFCell cell){
        String ret="";
        switch (cell.getCellType()){
            case HSSFCell.CELL_TYPE_STRING:
                ret=cell.getStringCellValue();
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                ret=cell.getNumericCellValue()+"";
                break;
            case HSSFCell.CELL_TYPE_FORMULA:
                ret=cell.getCellFormula();
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                ret=cell.getBooleanCellValue()+"";
                break;
                default:
                    ret="";
        }

        return ret;
    }
}
