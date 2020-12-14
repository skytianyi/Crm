package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);


    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    /**
     * 查询符合条件线索
     * @param map
     * @return
     */
    List<Clue> selectClueByCondition(Map<String,Object> map);

    /**
     * 查询符合条件的线索条数
     * @param map
     * @return
     */
    int selectCountClueByCondition(Map<String,Object> map);

    /**
     * 添加线索
     * @param clue
     * @return
     */
    int insertClue(Clue clue);

    /**
     * 根据id查返回线索,有的字段是id编号
     * @param id
     * @return
     */
    Clue selectClueById(String id);

    /**
     * 更新线索
     * @param clue
     * @return
     */
    int updateClueById(Clue clue);

    /**
     * 跟据id数组批量删除线索
     * @param ids
     * @return
     */
    int deleteClueByIds(String[] ids);

    /**
     * 根据id查询线索的详细信息
     * @param id
     * @return
     */
    Clue selectClueForDetailById(String id);



}