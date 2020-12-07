package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/13 0013
 */

public interface ActivityService {

    /**
     * 保存市场活动
     * @param activity
     * @return
     */
    int saveCreateActivity(Activity activity);

    /**
     * 按条件查询市场活动
     * @param map
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    /**
     * 符合条件的市场活动总条数
     * @param map
     * @return
     */
    int queryCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 批量删除市场活动
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id号查询市场活动
     * @param id
     * @return
     */
    Activity queryActivityById(String id);

    /**
     * 更新市场活动
     * @param activity
     * @return
     */
    int editActivity(Activity activity);

    /**
     * 查询所有的市场活动
     * @return
     */
    List<Activity> queryAllActivity();

    /**
     * 根据多个id查询市场活动
     * @param ids
     * @return
     */
    List<Activity> queryActivityByIds(String[] ids);

    /**
     * 保存上传的市场活动
     * @param activities
     * @return
     */
    int saveCreateAcitivtyByList(List<Activity> activities);

    Activity queryActivityForDetailById(String id);
}
