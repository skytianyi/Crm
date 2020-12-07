package com.bjpowernode.Test;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileOutputStream;
import java.io.OutputStream;

/**
 * @author 栗舜顺
 * 2020/11/19 0019
 */
public class CreateExcelTest {

    @Test
    public void createExcelTest() throws Exception{

        //1.创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb=new HSSFWorkbook();
        //2.使用wb创建HSSFSheet对象，对应一个页
        HSSFSheet sheet = wb.createSheet("学生列表");
        //3.使用sheet创建HSSFRow对象，对应一行
        HSSFRow row = sheet.createRow(0);
        //4.使用row创建3个HSSFCell对象,对应3列
        HSSFCell cell = row.createCell(0);
        //5.往列中写内容
        cell.setCellValue("学号");
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        cell = row.createCell(2);
        cell.setCellValue("年龄");

        //创建HSSFCellStyle对象，定义了一系列属性，从各个角度对列进行修饰
        HSSFCellStyle style=wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);

        //使用sheet创建10个HSSFRow对象，对应10行
        for (int i = 1; i <=10; i++) {
            row=sheet.createRow(i);

            //使用row创建3个HSSFCell对象，对应3列
            cell = row.createCell(0);
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("张三"+i);
            cell = row.createCell(2);
            cell.setCellValue(20+i);
        }

        //6.调用工具方法，生成excel文件
        OutputStream os=new FileOutputStream("K:\\全新学习\\19-crm\\文档\\studentList.xls");
        wb.write(os);

        //关闭资源
        os.close();
        wb.close();



    }
}
