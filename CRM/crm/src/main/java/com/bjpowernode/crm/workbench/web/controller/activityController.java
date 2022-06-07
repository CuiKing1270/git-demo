package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.pojo.ReturnObject;
import com.bjpowernode.crm.commons.utils.CreateUUID;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.bjpowernode.crm.settings.pojo.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.pojo.Activity;
import com.bjpowernode.crm.workbench.pojo.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.logging.log4j.core.util.UuidUtil;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;




import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;

import java.util.*;

// 进行市场活动的页面的跳转
@Controller
public class activityController {
    @Autowired // 自动注入Service对象
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;
    // 市场活动主页面
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){ // 通过request 来保存到数据
        List<User> userList = userService.queryAllUsers(); // 通过service层获取到数据。
        request.setAttribute("userList",userList); // 通过request 来将数据保存到 数据域中
        return "/workbench/activity/index";
    }
    // 这里要返回一个JSON字符串  所以我们要使用Object类型。@ResponseBody 表示该方法自动返回json字符串

    /**
     *  往市场活动中添加数据
     *  该方法的作用  用来处理数据的
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @Transactional(readOnly = false)
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER); // 获取用户的数据
        // 封装数据
        // 我们进行参数的封装。 我们需要封装id id的话 我们需要通过UUID来进行生成
        activity.setId(CreateUUID.getUUID());
        // 获取当前创建时间
        activity.setCreateTime(DateUtils.formartTime(new Date()));
        // 获取其他数据 通过用户的id来进行获取
        activity.setCreateBy(user.getId());
        // 创建返回数据的对象
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用service层来进行数据的校验
            int res = activityService.SaveCreateActivity(activity);
            // 判断 数据的结果
            if (res>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("系统繁忙,请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace(); // 打印异常信息

            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统繁忙,请稍后重试....");
        }
        return returnObject;
    }

    /**
     *  返回 json 字符串
     * @param name 市场活动的名字
     * @param owner  所有者的名字
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param pageNo 页数
     * @param pageSize 每页显示的条数
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody  Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize){
        // 将参数封装到 市场活动中
        Map<String,Object> map = new HashMap<>();
        map.put("name" ,name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize); // 开始的页数
        map.put("pageSize",pageSize);
            // 根据条件查询数据
            List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
            int totalRows = activityService.queryCountOfActivityByCondition(map);
            // 根据查询信息结果生成,map集合 这里我们可以放入到map集合中也可以放入到实体类对象中
            Map<String,Object> resMap = new HashMap<>();
            resMap.put("activityList",activityList); // 查询结果集
            resMap.put("totalRows",totalRows); // 查询记录的总条数

        return  resMap;
    }

    /**
     *  往市场活动中进行数据的删除
     *  根据id进行删除
     *  返回一个json字符串进行解析
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityIds.do")
    public @ResponseBody Object deleteActivityIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        // 调用service层函数
        try {
            int res = activityService.deleteActivityByIds(id);
            // 如果影响的行数大于0 则表名删除成功
            if (res>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("系统忙,请稍后重试！");
            }
        }catch (Exception e){
            // 打印异常信息
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统忙,请稍后重试！");
        }

        return  returnObject;
    }

    /**
     *  修改市场活动中的数据 第一步 先查数据。
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        // 通过id进行查询。 调用service层的方法进行查询
        Activity activity = activityService.queryActivityById(id);
        // 将查到的对象封装成json字符串
        return activity;
    }

    /**
     *  修改市场活动第二步
     * @param activity
     * @return
     */
    @RequestMapping("/workbench/activity/saveEditActivity.do")
    public @ResponseBody Object saveEditActivity(Activity activity,HttpSession session){
        // 创建user对象 通过user表中的主键来获取user的id值，这样可以保证唯一
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 创建时间 没办法从前台获取 我们需要在这里进行创建
        activity.setEditTime(DateUtils.formartTime(new Date())); // 获取生成时间
        activity.setEditBy(user.getId());  // 获取创建者
        // 创建工具类 生成json字符串
        ReturnObject returnObject = new ReturnObject();
        // 调用service层的方法  判断影响的行数
        try{
            int res =activityService.saveEditActivity(activity);
            if (res>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("系统繁忙,请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace(); // 打印堆栈信息
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }
        return  returnObject;
    }

    /**
     *  导出市场活动
     * @param response
     * @throws Exception
     */
    @RequestMapping("/workbench/activity/exportAllActivitys.do")
    public void exportAllActivitys(HttpServletResponse response) throws Exception{
        //调用service层方法，查询所有的市场活动
        List<Activity> activityList=activityService.queryAllActivitys();
        //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet=wb.createSheet("市场活动列表");
        HSSFRow row=sheet.createRow(0);
        HSSFCell cell=row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");

        //遍历activityList，创建HSSFRow对象，生成所有的数据行
        if(activityList!=null && activityList.size()>0){
            Activity activity=null;
            for(int i=0;i<activityList.size();i++){
                activity=activityList.get(i);

                //每遍历出一个activity，生成一行
                row=sheet.createRow(i+1);
                //每一行创建11列，每一列的数据从activity中获取
                cell=row.createCell(0);
                cell.setCellValue(activity.getId());
                cell=row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell=row.createCell(2);
                cell.setCellValue(activity.getName());
                cell=row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell=row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell=row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell=row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell=row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell=row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell=row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell=row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //根据wb对象生成excel文件
       /* OutputStream os=new FileOutputStream("E:\\尚硅谷\\Acitvity.xls");
        wb.write(os);*/
        //关闭资源
        //os.close();
        wb.close();

        //把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream out=response.getOutputStream();
       /* InputStream is=new FileInputStream("E:\\尚硅谷\\Acitvity.xls");
        byte[] buff=new byte[256];
        int len=0;
        while((len=is.read(buff))!=-1){
            out.write(buff,0,len);
        }
        is.close();*/

        wb.write(out); // 将输出流写入到市场活动中。不需要临时在磁盘上建立文件。

        wb.close();

        out.flush();
    }

    /**
     *  导入市场活动
     * @param activityFile
     * @param userName
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody Object importActivity(MultipartFile activityFile,String userName,HttpSession session){
        System.out.println("userName="+userName);
        User user=(User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject=new ReturnObject();
        try {
            //把excel文件写到磁盘目录中
            /*String originalFilename = activityFile.getOriginalFilename();
            File file = new File("D:\\course\\18-CRM\\阶段资料\\serverDir\\", originalFilename);//路径必须手动创建好，文件如果不存在，会自动创建
            activityFile.transferTo(file);*/

            //解析excel文件，获取文件中的数据，并且封装成activityList
            //根据excel文件生成HSSFWorkbook对象，封装了excel文件的所有信息
            //InputStream is=new FileInputStream("D:\\course\\18-CRM\\阶段资料\\serverDir\\"+originalFilename);

            InputStream is=activityFile.getInputStream(); // 获取输入流。
            HSSFWorkbook wb=new HSSFWorkbook(is);
            //根据wb获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet=wb.getSheetAt(0);//页的下标，下标从0开始，依次增加
            //根据sheet获取HSSFRow对象，封装了一行的所有信息
            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            List<Activity> activityList=new ArrayList<>();
            for(int i=1;i<=sheet.getLastRowNum();i++) {//sheet.getLastRowNum()：最后一行的下标
                row=sheet.getRow(i);//行的下标，下标从1开始，依次增加
                activity=new Activity();
                activity.setId(CreateUUID.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formartTime(new Date()));
                activity.setCreateBy(user.getId());

                for(int j=0;j<row.getLastCellNum();j++) {//row.getLastCellNum():最后一列的下标+1
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell=row.getCell(j);//列的下标，下标从0开始，依次增加
                    //获取列中的数据
                    String cellValue=HSSFUtils.getNumericCellValueStr(cell);
                    if(j==0){ // 从第二列开始，因为第0列和第1列已经被赋值了。
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if(j==4){
                        activity.setDescription(cellValue);
                    }
                }

                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }

            //调用service层方法，保存市场活动
            int ret=activityService.saveCreateActivityByList(activityList);

            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(ret);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;
    }







        /**
         *  批量选择 想要导出的市场活动
         * @param id
         * @throws IOException
         */
        @RequestMapping("/workbench/activity/queryCheckedActivity.do")
        public void queryCheckedActivity(String[] id,HttpServletResponse response) throws IOException {

            // 调用service层的方法
            List<Activity> activityList = activityService.queryCheckedActivity(id);
            // 创建Excel文件
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("市场活动(选择版)");// 创建页
            HSSFRow row = sheet.createRow(0);// 创建行
            HSSFCell cell = row.createCell(0); // 创建列；
            cell.setCellValue("ID"); // 创建第一行第一列中的数据
            cell = row.createCell(1);
            cell.setCellValue("创建者");
            cell = row.createCell(2);
            cell.setCellValue("名字");
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

            // 判断我们是否查询到数据
            if (activityList!=null && activityList.size()>0){
                Activity activity=null;
                for (int i = 0; i < activityList.size(); i++) {
                    activity=activityList.get(i); // 获取实体类对象
                    // 创建第二行
                    row.createCell(i+1);
                    //每一行创建11列，每一列的数据从activity中获取
                    cell=row.createCell(0);
                    cell.setCellValue(activity.getId());
                    cell=row.createCell(1);
                    cell.setCellValue(activity.getOwner());
                    cell=row.createCell(2);
                    cell.setCellValue(activity.getName());
                    cell=row.createCell(3);
                    cell.setCellValue(activity.getStartDate());
                    cell=row.createCell(4);
                    cell.setCellValue(activity.getEndDate());
                    cell=row.createCell(5);
                    cell.setCellValue(activity.getCost());
                    cell=row.createCell(6);
                    cell.setCellValue(activity.getDescription());
                    cell=row.createCell(7);
                    cell.setCellValue(activity.getCreateTime());
                    cell=row.createCell(8);
                    cell.setCellValue(activity.getCreateBy());
                    cell=row.createCell(9);
                    cell.setCellValue(activity.getEditTime());
                    cell=row.createCell(10);
                    cell.setCellValue(activity.getEditBy());
                }
                // 创建文件了之后 进行什么呢？
                wb.close(); // 关闭流
                // 把生成的Excel文件生成到客户端
                response.setContentType("application/octet-stream;charset=UTF-8");
                // 编写请求头
                response.addHeader("Content-Disposition","attachment;filename=checkActivityList.xls");
                OutputStream out = response.getOutputStream();

                // 写入 输入流
                wb.write(out);
                // 关闭流
                wb.close();
                out.flush();// 将输出流写入到市场活动中。不需要临时在磁盘上建立文件。
            }
        }

            /**
             *  返回要跳转的资源路径，所以我们需要返回一个String类型的字符串。
              * @param id
             * @param
             * @return
             */
            @RequestMapping("/workbench/activity/queryActivityForDetail.do")
            public String queryActivityForDetail(String id,HttpServletRequest request){
                   // 调用市场活动的service
                    Activity activity = activityService.queryActivityForDetail(id);
                    // 调用备注的service方法
                List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
                // 将数据注入到request域中
                request.setAttribute("activity",activity);
                request.setAttribute("remarkList",remarkList);

                // 返回要跳转的网页
               return "workbench/activity/detail";
            }



//    /**
//     * 测试 文件的下载。
//     * @param response
//     */
//    @RequestMapping("/workbench/activity/ActivityFileExcel.do")
//    public void ActivityFileExcel(HttpServletResponse response){
//        // 通过 response 来 进行相应信息的读取  这里我们需要获取的是一个二进制字节流
//        // 设置响应类型
//        response.setContentType("application/octet-stream;charset=UTF-8");
//        OutputStream out = null;
//        InputStream in = null;
//        try {
//            // 获取输出流
//            out = response.getOutputStream();
//
//            // 浏览器接收到响应信息之后,默认情况下,直接在显示窗口中打开响应信息,即使打不开,也会调用响应的程序打开(电脑自带的),最后实在打不开才会激活文件下载窗口
//            // 我们可以设置响应头信息，即使浏览器接收到响应信息之后，直接激活文件下载窗口，即使能打开也不打开
//            response.addHeader("Content-Disposition","attachment;filename=myStudent.xls");
//
//
//            // 读取excel文件(InputStream)，将其输出到浏览器(OutputSteam);
//            // 获取文件输入流。
//            in = new FileInputStream("E:\\尚硅谷\\student.xls");
//            // 读取输入流 我们需要建立一个缓冲区
//            byte[] bytes = new byte [256];
//            //in.read(bytes);// 读取输入流
//            int len = 0;
//            while ((len = in.read(bytes))!=-1){
//                // 我们将其文件写出到浏览器中
//                out.write(bytes,0,len); // 三个参数 分别是 缓冲区大小,从哪个开始读，一次读几个字节
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//        }finally {
//            // 关闭文件输入流和输出流
//            try {
//                in.close();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//            try {
//                out.flush();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//    }





}
