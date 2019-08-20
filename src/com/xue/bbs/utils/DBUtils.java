package com.xue.bbs.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 获取数据库连接，关闭连接等操作
 * @author xuexue
 *
 */
public class DBUtils {
	//数据库驱动
	private static final String driver = "com.mysql.jdbc.Driver";
	//数据库url
	private static final String url = "jdbc:mysql://localhost:3306/bbs?useUnicode=true&characterEncoding=UTF-8";
	//数据库名称
	private static final String username = "root";
	//数据库密码
	private static final String password = "1104428690A";
	//数据库连接
	private static Connection connection = null;
	
	/**
	 * 获取数据库连接
	 * @return 数据库连接
	 */
	public static Connection getConnection() {
		try {
			//加载驱动
			Class.forName(driver);
			//获得连接
			connection = DriverManager.getConnection(url, username, password);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//返回连接
		return connection;
	}
	
	/**
	 * 关闭数据库连接
	 * @param connection
	 */
	public static void close(Connection connection) {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 关闭预编译
	 * @param pret
	 */
	public static void close(PreparedStatement pret) {
		if (pret != null) {
			try {
				pret.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 关闭结果集
	 * @param rs
	 */
	public static void close(ResultSet rs) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
