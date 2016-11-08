package com.thinkgem.jeesite.common.utils.excel.entity;


public class HeaderCellEntity {
	
	// 值
	private String value;
	// 合并行
	private int rowspan;

	// 合并列
	private int colspan;

	/**
	 * @param value 单元格值
	 * @param rowspan 合并行
	 * @param colspan 合并列
	 */
	public HeaderCellEntity(String value,int rowspan,int colspan) {
		this.value = value;
		this.rowspan = rowspan;
		this.colspan = colspan;
	}
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	public int getRowspan() {
		return rowspan;
	}
	public void setRowspan(int rowspan) {
		this.rowspan = rowspan;
	}
	public int getColspan() {
		return colspan;
	}
	public void setColspan(int colspan) {
		this.colspan = colspan;
	}

}
