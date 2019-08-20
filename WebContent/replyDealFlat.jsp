<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	/*
	*此页面为回复帖子（平板）
	*/
	//设置字符编码
	request.setCharacterEncoding("utf-8");
	//从回复帖子页面获取帖子信息
	int id = Integer.parseInt(request.getParameter("pid") == null ? "-1" : request.getParameter("pid"));
	int rootid = Integer.parseInt(request.getParameter("rootid") == null ? "-1" : request.getParameter("rootid"));
	String title = request.getParameter("title");
	String cont = request.getParameter("cont");
	
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success") && id != -1 && rootid != -1) {
		//定义预编译处理类
		PreparedStatement pret = null;
		//定义返回结果集
		ResultSet rs = null;
		//定义数据库连接
		Connection con = null;
		try {
			//获取数据库连接
			con = DBUtils.getConnection();
			//将自动提交事务，改成手动提交
			con.setAutoCommit(false);
			//编写sql插入语句
			String sql = "INSERT INTO `bbs`.`article` (`pid`, `rootid`, `title`, `cont`, `pdate`, `isleaf`) VALUES (?,?, ?, ?, now(), ?)";
			//预编译sql语句，此时还没执行
			pret = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			//设置插入条件
			pret.setInt(1, id);
			pret.setInt(2, rootid);
			pret.setString(3, title);
			pret.setString(4, cont);
			pret.setInt(5, 0);
			//执行sql语句，插入，插入成功返回受影响的行数
			int num = pret.executeUpdate();
			
			//修改父贴的叶子节点为1
			sql = "update article set isleaf = ? where id = ?";
			//预编译
			pret = con.prepareStatement(sql);
			//设置插入条件
			pret.setInt(1, 1);
			pret.setInt(2, id);
			//执行插入
			pret.executeUpdate();
			//手动提交事务
			con.commit();
			con.setAutoCommit(true);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBUtils.close(con);
			DBUtils.close(pret);
			DBUtils.close(rs);
		}
	} else {
		response.sendRedirect("err.jsp");
	}

%>

<span id="time" style="background:red">3</span>秒后自动跳转,如果不跳转请点击
<script language="JavaScript1.2" type="text/javascript">
	function delayURL(url) {
		var delay = document.getElementById("time").innerHTML;
		//alert(delay);
		if(delay > 0) {
			delay--;
			document.getElementById("time").innerHTML = delay;
		} else {
			window.top.location.href = url;
		}
		//每隔一秒钟调用一次
		setTimeout("delayURL('" + url + "')", 1000);

	}
</script>

<a href="articleFlat.jsp">主题列表</a>

<script type="text/javascript">
	delayURL("articleFlat.jsp");
</script>

<html>

<head>

	<body>
		<p>回复成功!</p><br>
		<a href="articleFlat.jsp">点击返回主论坛</a>
	</body>

</html>