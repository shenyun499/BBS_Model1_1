<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
/*
 *此页面为检验登陆操作，只有登陆了才可以对论坛进行增删改等操作
*/
String isAction = request.getParameter("action");
//验证登陆
if (isAction != null && isAction.equals("isTrue")) {
	//从登陆页面获取登陆信息
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	//判断登陆信息
	if (username != null && password != null && username != "" && password != "") {
		//定义预编译处理类
		PreparedStatement pret = null;
		//定义返回结果集
		ResultSet rs = null;
		//定义数据库连接
		Connection con = null;
		try {
			//获取数据库连接
			con = DBUtils.getConnection();
			//编写sql查询语句
			String sql = "select *from buser where username = ? and password = ?";
			//预编译sql语句，此时还没执行
			pret = con.prepareStatement(sql);
			//设置查询条件
			pret.setString(1, username);
			pret.setString(2, password);
			//执行sql语句，返回结果
			rs = pret.executeQuery();
			if (rs.next()) {
				//说明有值，设置session并转发到论坛主页面
				session.setAttribute("user", "success");
				response.sendRedirect("articleFlat.jsp");
			} else {
				//信息验证错误，则转发回login.jsp页面
				response.sendRedirect("loginFail.jsp");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBUtils.close(con);
			DBUtils.close(pret);
			DBUtils.close(rs);
		}
	} else {
		//信息验证错误，则转发回login.jsp页面
		response.sendRedirect("loginFail.jsp");
	}
}
%>

<html>

	<head>
		<title>管理员登录</title>
	</head>

	<body>
		<form action="login.jsp" method="post">
			<input type="hidden" name="action" value="isTrue" />
			用户名：
			<input type="text" name="username" />
			<br> 
			密码：
			<input type="password" name="password" />
			<br>
			<input type="submit" />
		</form>
	</body>

</html>