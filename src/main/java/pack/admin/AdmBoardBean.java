package pack.admin;

public class AdmBoardBean {
	private int num;
	private String admId; 						
	private String admName;		
	private String subject;     
	private String content;		    
	private int readcnt;
	private String filename;	
	private String oriFilename;	
	private int filesize;	
	private int post;		
	private int fixed;	
	private int type;		
	private String saveTM;	
	private String postTM;
	
	public AdmBoardBean() {}
	public AdmBoardBean(int num, String admId, String admName, String subject, String content, int readcnt, String filename, String oriFilename, int filesize, int post	,int fixed,int type	,String saveTM, String postTM) {
		this.num = num;
		this.admId = admId;
		this.admName = admName;
		this.subject = subject;
		this.content = content;
		this.readcnt = readcnt;
		this.filename = filename;
		this.oriFilename = oriFilename;
		this.filesize = filesize;
		this.post = post;
		this.fixed = fixed;
		this.type = type;
		this.saveTM = saveTM;
		this.postTM = postTM;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getAdmId() {
		return admId;
	}
	public void setAdmid(String admId) {
		this.admId = admId;
	}
	public String getadmName() {
		return admName;
	}
	public void setadmName(String admName) {
		this.admName = admName;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getReadcnt() {
		return readcnt;
	}
	public void setReadcnt(int readcnt) {
		this.readcnt = readcnt;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getOriFilename() {
		return oriFilename;
	}
	public void setOriFilename(String oriFilename) {
		this.oriFilename = oriFilename;
	}
	public int getFilesize() {
		return filesize;
	}
	public void setFilesize(int filesize) {
		this.filesize = filesize;
	}
	public int getPost() {
		return post;
	}
	public void setPost(int post) {
		this.post = post;
	}
	public int getFixed() {
		return fixed;
	}
	public void setFixed(int fixed) {
		this.fixed = fixed;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public String getSaveTM() {
		return saveTM;
	}
	public void setSaveTM(String saveTM) {
		this.saveTM = saveTM;
	}
	public String getPostTM() {
		return postTM;
	}
	public void setPostTM(String postTM) {
		this.postTM = postTM;
	}
	
}
