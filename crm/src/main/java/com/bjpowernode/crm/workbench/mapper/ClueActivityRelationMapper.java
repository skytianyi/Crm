package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation record);

    int insertSelective(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation record);

    int updateByPrimaryKey(ClueActivityRelation record);

    /**
     * 批量添加线索市场活动关系
     * @param relationList
     * @return
     */
    int insertClueActivityRelationByList(List<ClueActivityRelation> relationList);

    /**
     * 根据clueId和市场活动id删除线索和市场活动关系
     * @param car
     * @return
     */
    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation car);

    /**
     * 根据clueId查询对应的线索和市场活动关系
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> selectCluActRelationByClueId(String clueId);

    /**
     * 根据clueId删除对应的线索和市场活动关系
     * @param id
     */
    void deleteClueActivityRelationByClueId(String id);
}