package com.bjpowernode.crm.test;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;

import java.io.InputStream;

/**
 *  测试打印表格
 */
public class ParseExcelTest {
    public static void main(String[] args) throws Exception {
        // 首先获取表格,通过输入流  因为我们要写表格 所以我们需要进行输入流
        InputStream in = new FileInputStream("D:\\下载\\activityList(1).xls");
        HSSFWorkbook hssfWorkbook  = new HSSFWorkbook(in); // poi插件中的类需要一个输入流
        HSSFSheet sheet = hssfWorkbook.getSheetAt(hssfWorkbook.getActiveSheetIndex()); // 获取页的数据
        // 获取行的数目
        HSSFRow row = null;
        HSSFCell cell = null;
        for (int i = 0; i <=sheet.getLastRowNum() ; i++) {
            row  = sheet.getRow(i);// 获取行并编写
            for (int j = 0; j <row.getLastCellNum(); j++) { // 获取表中的列
                cell = row.getCell(j);
                System.out.print(getNumericCellValueStr(cell) + " ");
            }
            System.out.println();
        }


    }

    /**
     *
     * @param cell  我们传入列
     * @return
     */
    public static String getNumericCellValueStr(HSSFCell cell){
        String res = ""; // 我们定义一个空的字符串 然后将其返回
        if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
            res = cell.getNumericCellValue()+""; // 我们将数值型返回成字符串类型
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
            res = cell.getStringCellValue();
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA){
            res = cell.getCellFormula()+" ";
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN) {
            res= cell.getCellFormula()+" ";
        }else{
            res = "";
        }
        return  res;
    }

}
