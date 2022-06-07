package com.bjpowernode.crm.test;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class CreateExcelTest {
    public static void main(String[] args) throws IOException {

        HSSFWorkbook wb = new HSSFWorkbook(); // 创建文件
        // 修饰表中的数据的属性
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.RIGHT); // 将列居中。

        // 使用文件对象来创建页对象。
        HSSFSheet sheet = wb.createSheet("学生信息"); //  创建文件中的页，相当于excel表中的一个表
        HSSFRow row = sheet.createRow(0);// 创建页中的行。 下标从0开始 0表示的是第一行
        HSSFCell cell = row.createCell(0); // 创建页中的列 第一行第一列
        cell.setCellStyle(style);
        cell.setCellValue("学生学号"); // 第一行第一列中的数据表示
        cell=row.createCell(1); // 第一行第二列
        cell.setCellStyle(style); // 设置第一行第一列的样式
        cell.setCellValue("姓名"); // 第一行第二列的值
        cell=row.createCell(2); // 第一行第三列。
        cell.setCellStyle(style);
        cell.setCellValue("年龄");


        // 创建第二行第一列
        for (int i = 1; i <=10 ; i++) {
            row = sheet.createRow(i); // 创建第二行

            cell = row.createCell(0); // 从第0列开始 依次增加
            cell.setCellValue(100+i); // 赋予列的值
            cell = row.createCell(1);
            cell.setCellStyle(style);
            cell.setCellValue("NAME"+i);
            cell = row.createCell(2);
            cell.setCellValue(20+i);
        }
        // 调用文件输出流
        FileOutputStream file = null;
        try {
             file = new FileOutputStream("E:\\尚硅谷\\student.xls");
            wb.write(file); // 将文件写出到指定的路径
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            file.close();
            wb.close();
        }
        System.out.println("=================create ok===========");
    }
}
