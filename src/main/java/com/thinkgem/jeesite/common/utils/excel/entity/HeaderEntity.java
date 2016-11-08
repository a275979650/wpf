package com.thinkgem.jeesite.common.utils.excel.entity;

import java.util.List;

import com.google.common.collect.Lists;

public class HeaderEntity {
	
	private List<HeaderCellEntity> thead;
	/*
	 * 最大的列数
	 */
	private int cols=1;
	
	public HeaderEntity(int cols){
		if(this.thead ==null){
			thead = Lists.newArrayList();
		}
		this.cols = cols;
	}
	
	public int getCols() {
		return cols;
	}

	public void setCols(int cols) {
		this.cols = cols;
	}

	public HeaderEntity(int cols,List<HeaderCellEntity> thead){
		this.thead = thead;
		if(this.thead ==null){
			thead = Lists.newArrayList();
		}
		this.cols = cols;
	}
	
	public List<HeaderCellEntity> getThead(){
		return this.thead;
	}
	
	
	public void addCol(HeaderCellEntity cell){
		thead.add(cell);
	}
}
