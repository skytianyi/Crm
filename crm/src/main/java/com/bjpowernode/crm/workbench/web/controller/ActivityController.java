package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.HSSFUtils;
import com.bjpowernode.crm.commons.util.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

/**
 * @author 栗舜顺
 * 2020/11/13 0013
 */
@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/toIndex.do")
    public ModelAndView toIndex() {
        List<User> userList = userService.queryAllUsers();
        ModelAndView mv = new ModelAndView();
        mv.addObject("userList", userList);
        mv.setViewName("workbench/activity/index");
        return mv;
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody
    ReturnObject saveCreateActivity(Activity activity, HttpSession session) {
        String uuid = UUIDUtil.getUUID();
        activity.setId(uuid);

        User user = (User) session.getAttribute(MyConstans.USER);
        activity.setCreateBy(user.getId());

        activity.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = activityService.saveCreateActivity(activity);
            if (rows > 0) {
                return ReturnObject.success();
            } else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }

    }

    @RequestMapping("/workbench/activity/queryActivityByCondition.do")
    @ResponseBody
    public Object queryActivityByCondition(String name, String owner, String startDate, String endDate, int pageNo, int pageSize) {
        //当前页数
        int beginNo = (pageNo - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activityList);
        retMap.put("totalRows", totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] ids) {

        try {
            int rows = activityService.deleteActivityByIds(ids);
            if (rows > 0) {
                return ReturnObject.success();
            } else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }

    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id) {
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity, HttpSession session) {
        User user = (User) session.getAttribute(MyConstans.USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = activityService.editActivity(activity);
            if (rows > 0) {
                return ReturnObject.success();
            } else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    /*
      测试文件下载：通过流手动输出响应信息到浏览器，而不是借助controller方法的返回值返回响应信息，
      所以，这里方法的返回值类型定义成void。
    */
    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws Exception {
        //读取磁盘上指定的文件，输出到浏览器
        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头信息：
        //根据HTTP协议的规定，浏览器每次接收到响应信息,默认的打开方式是：直接在显示窗口打开；
        // 即使打不开，也会试图寻找应用软件打开；只有实在打不开时，才会弹出文件下载窗口。
        //我们可以设置响应头信息，使浏览器接收到响应信息之后，直接打开文件下载窗口，即使能打开，也不打开。
        response.addHeader("Content-Disposition", "attachment;filename=studentList" + DateTimeUtil.formateDateTimeYYYYMMDDHHMMSS(new Date()) + ".xls");

        //2.获取输出流出
        OutputStream out = response.getOutputStream();
        //3.通过InputStream读取excel文件，通过outstream输出把文件输出到浏览器
        InputStream is = new FileInputStream("K:\\全新学习\\19-crm\\文档\\studentList.xls");

        byte[] buff = new byte[256];
        int len = 0;
        while ((len = is.read(buff)) != -1) {
            out.write(buff, 0, len);
        }
        //4.关闭资源
        is.close();
        out.flush();//资源谁开启的，谁关闭
    }

    @RequestMapping("/workbench/activity/exportAllActivitys.do")
    public void exportAllActivitys(HttpServletResponse response) throws Exception {
        List<Activity> activityList = activityService.queryAllActivity();
        //1.创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //2.使用wb创建HSSFSheet对象，对应一个页
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //3.使用sheet创建HSSFRow对象，对应一行
        HSSFRow row = sheet.createRow(0);
        //4.使用row创建3个HSSFCell对象,对应3列
        HSSFCell cell = row.createCell(0);
        //5.往列中写内容
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始时间");
        cell = row.createCell(4);
        cell.setCellValue("结束时间");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        Activity activity = null;
        for (int i = 0; i < activityList.size(); i++) {
            activity = activityList.get(i);
            row = sheet.createRow(i + 1);

            //4.使用row创建11个HSSFCell对象,对应11列
            cell = row.createCell(0);
            //5.往列中写内容
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditBy());
        }

        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头信息
        response.addHeader("Content-Disposition", "attachment;filename=activityList" + DateTimeUtil.formateDateTimeYYYYMMDDHHMMSS(new Date()) + ".xls");
        //2.获取输出流出
        OutputStream out = response.getOutputStream();
        //直接把wb中的数据输出到out中
        wb.write(out);

        //4.关闭资源
        //is.close();
        out.flush();//资源谁开启的，谁关闭
        wb.close();

    }

    @RequestMapping("/workbench/activity/exportActivityByIds.do")
    public void exportActivityByIds(String[] ids,HttpServletResponse response)throws Exception{
        List<Activity> activityList = activityService.queryActivityByIds(ids);
        //1.创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //2.使用wb创建HSSFSheet对象，对应一个页
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //3.使用sheet创建HSSFRow对象，对应一行
        HSSFRow row = sheet.createRow(0);
        //4.使用row创建3个HSSFCell对象,对应3列
        HSSFCell cell = row.createCell(0);
        //5.往列中写内容
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始时间");
        cell = row.createCell(4);
        cell.setCellValue("结束时间");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        Activity activity = null;
        for (int i = 0; i < activityList.size(); i++) {
            activity = activityList.get(i);
            row = sheet.createRow(i + 1);

            //4.使用row创建11个HSSFCell对象,对应11列
            cell = row.createCell(0);
            //5.往列中写内容
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditBy());
        }

        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头信息
        response.addHeader("Content-Disposition", "attachment;filename=activityList" + DateTimeUtil.formateDateTimeYYYYMMDDHHMMSS(new Date()) + ".xls");
        //2.获取输出流出
        OutputStream out = response.getOutputStream();
        //直接把wb中的数据输出到out中
        wb.write(out);

        //4.关闭资源
        //is.close();
        out.flush();//资源谁开启的，谁关闭
        wb.close();
    }

    @RequestMapping("/workbench/activity/fileUpload.do")
    @ResponseBody
    public Object  fileUpload(MultipartFile myFile,String userName) throws Exception{
        String originalFilename = myFile.getOriginalFilename();//文件名+后缀名
        System.out.println(originalFilename);

        File file=new File("K:\\全新学习\\19-crm\\文档\\"+originalFilename);
        //服务器磁盘上生成一个同样的文件
        myFile.transferTo(file);
       return ReturnObject.success();
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session){

        User user= (User) session.getAttribute(MyConstans.USER);
        try {
            //不经过磁盘效率变高
            InputStream is = activityFile.getInputStream();
            HSSFWorkbook wb=new HSSFWorkbook(is);
            //2.通过wb获取HSSFSheet对象，对应封装了一页的所有信息
            HSSFSheet sheet = wb.getSheetAt(0);

            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            List<Activity> activityList=new ArrayList<>();
            //3.根据sheet获取HSSFRow对象，对应封装了一行的所有信息
            for (int i = 1; i<=sheet.getLastRowNum(); i++) {    //sheet.getLastRowNum()：最后一行的编号
               row=sheet.getRow(i);
               activity=new Activity();
               activity.setId(UUIDUtil.getUUID());
               activity.setOwner(user.getId());
                activity.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                //4.根据row获取HSSFCell对象，对应封装了一列的所有信息
                for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum():最后一列的编号+1
                   cell= row.getCell(j);
                    String value = HSSFUtils.getCellValueForStr(cell);//获取列的值
                    if(j==0){
                        activity.setName(value);
                    }else if(j==1){
                        activity.setStartDate(value);
                    }else if(j==2){
                        activity.setEndDate(value);
                    }else if(j==3){
                        activity.setCost(value);
                    }else if(j==4){
                        activity.setDescription(value);
                    }
                }

                activityList.add(activity);
            }

            wb.close();
            //调用service层方法，批量保存创建的市场活动
            int ret = activityService.saveCreateAcitivtyByList(activityList);
            return ReturnObject.success(ret);

        } catch (IOException e) {
            e.printStackTrace();
            return ReturnObject.error("系统忙，请稍后重试.....");
        }
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detail(String id, HttpServletRequest request){
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        request.setAttribute("activity", activity);
        request.setAttribute("activityRemarkList", activityRemarkList);
        return "workbench/activity/detail" ;
    }
}
