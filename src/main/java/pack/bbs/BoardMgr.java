package pack.bbs;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import pack.dbcp.DBConnectionMgr;
import pack.gallery.GalleryBean;

public class BoardMgr {
	private DBConnectionMgr pool;
	
	Connection conn;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs;
	
	private static final String SAVEFOLER = "D:/AJR_20230126/Hong/silsp/p08_JSP/cheers_0420/src/main/webapp/fileupload";
	private static String encType = "UTF-8";
	private static int maxSize = 50 * 1024 * 1024; // 5mbyte 제한
	
	public BoardMgr() {
		pool = DBConnectionMgr.getInstance();
		try {
			conn = pool.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 게시판 입력(/bbs/postProc.jsp) 시작
	public void insertBoard(HttpServletRequest req) {
		String sql;
		MultipartRequest multi;
		int filesize = 0;
		String filename = null;
		String OriginalFileName = null;
		
		sql = "select max(num) from tblboard";
		try {
			pstmt= conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			int ref = 1;
			if(rs.next()) {
				ref = rs.getInt(1)+1;
			}
			
			File file = new File(SAVEFOLER);
			
			if(!file.exists()) {
				file.mkdir();
			}
			multi = new MultipartRequest(req, SAVEFOLER, maxSize, encType, new DefaultFileRenamePolicy());
			
			if(multi.getFilesystemName("filename")!=null) {
				OriginalFileName = multi.getOriginalFileName("filename");
				filename = multi.getFilesystemName("filename");
				filesize = (int)multi.getFile("filename").length();
			}
			String content = multi.getParameter("content");
			
			if(multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
				content = UtilMgr.replace(content, "<", "&lt");
			}
			
			sql = "insert into tblboard(";
			sql += "uid, uname, subject, content, ref, pos, depth, ";
			sql += "regtm, ip, readcnt, filename, filesize, oriFilename) values(";
			sql += "?,?,?,?,?,0,0,now(),?,0,?,?,?)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, multi.getParameter("uid"));
			pstmt.setString(2, multi.getParameter("uname"));
			pstmt.setString(3, multi.getParameter("subject"));
			pstmt.setString(4, content);
			pstmt.setInt(5, ref);
			pstmt.setString(6, multi.getParameter("ip"));
			pstmt.setString(7, filename);
			pstmt.setInt(8, filesize);
			pstmt.setString(9, OriginalFileName);
			pstmt.executeUpdate();
			
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
	}
	
	// 게시판 리스트 출력(/bbs/list.jsp) 시작
	public Vector<BoardBean> getBoardList(String keyField, String keyWord, int start, int end){
		Vector<BoardBean> vList = new Vector<>();
		String sql;
		
		try {
			if(keyWord.equals("null")||keyWord.equals("")) {
				sql = "select * from tblboard";
				sql	+= " order by ref desc, pos asc limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				sql = "select * from tblboard where "+keyField+" like ?" 
						+" order by ref desc, pos asc limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyWord+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bean = new BoardBean();
				bean.setNum(rs.getInt("num"));
				bean.setUname(rs.getString("uname"));
				bean.setSubject(rs.getString("subject"));
				bean.setPos(rs.getInt("pos"));
				bean.setRef(rs.getInt("ref"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegtm(rs.getString("regtm"));
				bean.setReadcnt(rs.getInt("readcnt"));
				bean.setFilename(rs.getString("filename"));
				vList.add(bean);
			}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(conn, pstmt, rs);
			}
		
		return vList;
	}
	// 게시판 리스트 출력(/bbs/list.jsp) 끝
	
	// 총 게시물 수(/bbs/list.jsp) 시작
	public int getTotalCount(String keyField, String keyWord) {
		String sql;
		int totalCnt=0;
		
		try {
			if(keyWord.equals("null")||keyWord.equals("")) {
				sql = "select count(*) from tblboard";
					pstmt = conn.prepareStatement(sql);
			} else {
				sql = "select count(*) from tblboard"
						+" where "+keyField+" like ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyWord+"%");
			}
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				totalCnt = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalCnt;
	}
	
	// 게시판 뷰페이지 조회수 증가 시작 (/bbs/read.jsp 내용보기 페이지)
	public void upCount(int num) {
		String sql = null;
		
		try {
			sql = "update tblboard set readcnt = readcnt+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt);
		}
	}
	// 게시판 뷰페이지 조회수 증가 끝 (/bbs/read.jsp 내용보기 페이지)
	
	// 상세보기 페이지 게시글 출력 시작 (/bbs/read.jsp 내용보기 페이지)
	public BoardBean getBoard(int num) {
		String sql = null;
		
		BoardBean bean = new BoardBean();
		
		try {
			sql = "select * from tblboard where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				bean.setNum(rs.getInt("num"));
				bean.setUid(rs.getString("uid"));
				bean.setUname(rs.getString("uname"));
				bean.setSubject(rs.getString("subject"));
				bean.setContent(rs.getString("content"));
				bean.setPos(rs.getInt("pos"));
				bean.setRef(rs.getInt("ref"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegtm(rs.getString("regtm"));
				bean.setReadcnt(rs.getInt("readcnt"));
				bean.setFilename(rs.getString("filename"));
				bean.setFilesize(rs.getInt("filesize"));
				bean.setIp(rs.getString("ip"));
				bean.setOriFilename(rs.getString("oriFilename"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
		return bean;
	}
	// 상세보기 페이지 게시글 출력 끝 (/bbs/read.jsp 내용보기 페이지)
	
	// 상세보기 페이지 파일 다운로드 시작
	public static int len;
	public void downLoad(HttpServletRequest req, HttpServletResponse res, JspWriter out, PageContext pageContext) {
		try {
			req.setCharacterEncoding("UTF-8");
			String filename = req.getParameter("filename"); // 다운로드할 파일 매개변수명 일치
			
			File file = new File(SAVEFOLER + File.separator + filename);

			byte[] b = new byte[(int) file.length()];			
			res.setHeader("Accept-Ranges", "bytes");
			req.getHeader("User-Agent");			
			res.setContentType("application/smnet;charset=UTF-8");
			
			res.setHeader("Content-Disposition", "attachment;fileName=" +
							new String(filename.getBytes("UTF-8"), "ISO-8859-1"));
			

			out.clear();
			out = pageContext.pushBody();

			if (file.isFile()) {
				BufferedInputStream fIn = new BufferedInputStream(new FileInputStream(file));
				BufferedOutputStream fOuts = new BufferedOutputStream(res.getOutputStream());
				int read = 0;
				while ((read = fIn.read(b)) != -1) {
					fOuts.write(b, 0, read);
				}
				fOuts.close();
				fIn.close();

			}

		} catch (Exception e) {
			System.out.println("파일 처리 이슈 : " + e.getMessage());
		}

	}
	// 상세보기 페이지 파일 다운로드 끝
	
	// 게시글 삭제(/bbs/delete.jsp) 시작
		public int deleteBoard(int num) {
			String sql = null;
			int exeCnt = 0;
			
			int ref = 0;
			int pos = 0;
			String uname = "";
			try {
				// 게시글 파일 삭제
				sql = "select * from tblboard where num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					if(rs.getString("filename")!=null) {
						String fName = rs.getString("filename");
						String fileSrc = SAVEFOLER + "/" + fName;
						File file = new File(fileSrc);
						
						if(file.exists()) file.delete();
						
					}
					ref = rs.getInt("ref");
					pos = rs.getInt("pos");
					uname = rs.getString("uname");
				}
				
				int unCnt = 0;
				
				sql = "select count(distinct uname) as unameCnt from tblboard where ref=? and pos>=? and num>=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, pos);
				pstmt.setInt(3, num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					unCnt = rs.getInt(1);
				}
				
				if(unCnt >= 2) {
					
					sql = "delete from tblboard where ref=? and pos>? and uname=? and num>?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					pstmt.setInt(2, pos);
					pstmt.setString(3, uname);
					pstmt.setInt(4, num);
					exeCnt = pstmt.executeUpdate();
					
					sql = "update tblboard set uname=?, subject=?, content=?, readcnt=?, ";
					sql += "uid=? where num=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "관리자");
					pstmt.setString(2, "삭제된 게시물 입니다.");
					pstmt.setString(3, "삭제된 게시물 입니다.");
					pstmt.setInt(4, 0);
					pstmt.setString(5, "-");
					pstmt.setInt(6, num);
					pstmt.execute();
					
				} else {
					sql = "delete from tblboard where ref=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					exeCnt = pstmt.executeUpdate();
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return exeCnt;
		}
		// 게시글 삭제(/bbs/delete.jsp) 끝
	
	// 게시글 수정페이지(/bbs/updateProc.jsp) 시작
	public int updateBoard(HttpServletRequest req) {
		String sql;
		MultipartRequest multi;
		int filesize = 0;
		String filename = null;
		String OriginalFileName = null;
		int exeCnt=0;
		
		try {
			File File = new File(SAVEFOLER);
			
			if(!File.exists()) {
				File.mkdir();
			}
			multi = new MultipartRequest(req, SAVEFOLER, maxSize, encType, new DefaultFileRenamePolicy());
			sql = "select filename, filesize, oriFilename from tblboard where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(multi.getParameter("num")));
			rs = pstmt.executeQuery();
			
			filename = multi.getFilesystemName("filename");
			OriginalFileName = multi.getOriginalFileName("filename");
			if(rs.next()) {
				String oldFile = rs.getString("filename");
				int oldFilesize = rs.getInt("filesize");
				String oldOriFilename = rs.getString("oriFilename");
				if(rs.getString(1)!=null&&filename!=null){
					String fileSrc = SAVEFOLER + "/" + oldFile;
					File file = new File(fileSrc);
					file.delete();
					filesize = (int)multi.getFile("filename").length();			
				}
				String content = multi.getParameter("content");
				if(multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
					content = UtilMgr.replace(content, "<", "&lt");
				}
				
				sql = "update tblboard set ";
				sql += "subject=?, content=?, filename=?, filesize=?, oriFilename=? ";
				sql += "where num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, multi.getParameter("subject"));
				pstmt.setString(2, content);
				if(rs.getString(1)!=null&&filename==null){
					pstmt.setString(3, oldFile);
					pstmt.setInt(4, oldFilesize);
					pstmt.setString(5, oldOriFilename);
				} else {
					pstmt.setString(3, filename);
					pstmt.setInt(4, filesize);
					pstmt.setString(5, OriginalFileName);
				}
				pstmt.setInt(6, Integer.parseInt(multi.getParameter("num")));
				exeCnt = pstmt.executeUpdate();
			} 
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt);
		}
		return exeCnt;
	}
	// 게시글 수정페이지(/bbs/updateProc.jsp) 끝
	
	// 게시글 답변페이지(/bbs/reply.jsp) 시작
	public int replyBoard(BoardBean bean) {
		String sql=null;
		int resCnt = 0;
		
		try {
			sql = "insert into tblboard ( uid, uname, content, ";
			sql += "subject, ref, pos, depth, regtm, readcnt, ";
			sql += "ip) values(?,?,?,?,?,?,?, now(),0,?)";
			
			int depth = bean.getDepth()+1;
			int pos = bean.getPos()+1;
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUid());
			pstmt.setString(2, bean.getUname());
			pstmt.setString(3, bean.getContent());
			pstmt.setString(4, bean.getSubject());
			pstmt.setInt(5, bean.getRef());
			pstmt.setInt(6, pos);
			pstmt.setInt(7, depth);
			pstmt.setString(8, bean.getIp());
			resCnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(conn, pstmt);
		}
		return resCnt;
	}
	// 게시글 답변페이지(/bbs/updateProc.jsp) 끝
	
	// 게시글 답변글 끼어들기(/bbs/replyProc.jsp) 시작
	public int replyUpBoard(int ref, int pos) {
		String sql = null;
		int cnt = 0;
		
		// 게시글의 포지션 증가 시작
		
		try {
			sql = "update tblboard set pos = pos +1 ";
			sql += "where ref = ? and pos > ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			pstmt.setInt(2, pos);
			cnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt);
		}
		return cnt;
	}
	// 게시글 답변글 끼어들기(/bbs/updateProc.jsp) 끝
	
	
}




























