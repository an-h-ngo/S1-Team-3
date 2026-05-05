package com.yoursjsu.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.yoursjsu.dao.CourseDAO;
import com.yoursjsu.dao.SectionDAO;
import com.yoursjsu.dao.TranscriptDAO;
import com.yoursjsu.model.Transcript;
import com.yoursjsu.model.User;

@WebServlet("/transcript")
public class TranscriptServlet extends HttpServlet {
	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        int userId = user.getUserId();
        Transcript transcript = TranscriptDAO.getSections(userId);
        request.setAttribute("transcript", transcript);
        request.getRequestDispatcher("/transcript.jsp").forward(request, response);
	}
}
