package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity activity);

    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    int selectCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    int updateActivity(Activity activity);

    List<Activity> selectAllActivity();

    List<Activity> selectActivityByIds(String[] ids);

    int insertActivityByList(List<Activity> activities);

    Activity selectActivityForDetailById(String id);

    List<Activity> selectActivityForDetailByClueId(String clueId);

    /**
     * 查询市场活动，并且排除与线索关联过的市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityForDetailByNameClueId(Map<String,Object> map);

    /**
     * 根据Ids查询所有符合条件的市场活动
     * @param ids
     * @return
     */
    List<Activity> selectActivityForDetailByIds(String[] ids);

    /**
     * 模糊查询所有与线索Id有关的市场活动
     * @param name
     * @param clueId
     * @return
     */
    List<Activity> selectActivityForConvertByNameClueId(@Param("name") String name,@Param("clueId") String clueId);

    /**
     *
     * @param name
     * @return
     */
    List<Activity> selectActivityForDetailByName(String name);
}