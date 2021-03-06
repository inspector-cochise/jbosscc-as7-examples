<%@page import="clustering.easy.ClusterMeStateful"%>
<%@page import="java.util.Date"%>
<%@page import="clustering.easy.ClusterMeStatefulRemote"%>
<%@page import="clustering.easy.ClusterMeStatelessRemote"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="clustering.easy.ClusterMeStateless"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Stateless</h1>
<%
	InitialContext ic = new InitialContext();
	ClusterMeStatelessRemote stateless = (ClusterMeStatelessRemote) ic.lookup("java:module/ClusterMeStateless");
%>
<p>Your stateless-session-bean is being processed by <b style="font-size: 20pt;"><%= stateless.whoAreYou() %></b>.</p>

<h1>Stateful</h1>
<%
	ClusterMeStatefulRemote stateful;
	
	if(session.getAttribute("stateful") == null)
	{
		%>
		<p>Looks like this is a new session... I will give you a fresh stateful-session-bean.</p>
		<%
		stateful = (ClusterMeStatefulRemote) ic.lookup("java:module/ClusterMeStateful");
		session.setAttribute("stateful", stateful);
	}
	else
	{
		stateful = (ClusterMeStatefulRemote) session.getAttribute("stateful");

		if(request.getParameter("killStateful") != null)
		{
			%>
			<p>Killing your stateful-session-bean.</p>
			<%
			stateful.killMe();
			%>
			<p>I will give you a fresh one now.</p>
			<%
			stateful = (ClusterMeStatefulRemote) ic.lookup("java:module/ClusterMeStateful");
			session.setAttribute("stateful", stateful);
		}
		else
		{
			%>
			<p>Using your formerly created stateful-session-bean.</p>
			<%
		}
	}
%>
<p>Your stateful-session-bean has been called <b style="font-size: 20pt;"><%= stateful.getCallcounter() %></b> times and is being processed by
<b style="font-size: 20pt;"><%= stateful.whoAreYou() %></b>.</p>
</body>
</html>
