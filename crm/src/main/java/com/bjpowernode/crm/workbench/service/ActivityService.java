package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

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

    /**
     * 根据id查询市场活动的详细信息
     * @param id
     * @return
     */
    Activity queryActivityForDetailById(String id);

    /**
     * 根据线索ID查询相关联的市场活动
     * @param clueId
     * @return
     */
    List<Activity> queryActivityForDetailByClueId(String clueId);

    /**
     * 查询没有与当前线索关联过的市场活动
     * @param map
     * @return
     */
    List<Activity> queryActivityForDetailByNameClueId(Map<String,Object> map);

    /**
     * 根据IDS批量查询符合条件的市场活动
     * @param ids
     * @return
     */
    List<Activity> queryActivityForDetailByIds(String[] ids);

    /**
     * 模糊查询所有与线索Id有关的市场活动
     * @param name
     * @param clueId
     * @return
     */
    List<Activity> queryActivityForConvertByNameClueId(String name,String clueId);


    /**
     * 根据市场活动name模糊查询符合的市场活动
     * @param name
     * @return
     */
    List<Activity> queryActivityForDetailByName(String name);
}
