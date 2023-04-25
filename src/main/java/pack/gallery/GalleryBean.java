package pack.gallery;

public class GalleryBean {
	private int num;
	private String uid;
	private String uname;
	private String subject;
	private String content;
	private String regtm;
	private String ip;
	private int readcnt;
	private String filename;
	private String oriFilename;
	private int filesize;
	
	public GalleryBean() {	}
	public GalleryBean(int num, String uid, String uname, String subject, String content, String regtm, String ip, int readcnt, String filename, String oriFilename, int filesize) {
		this.num = num;
		this.uid = uid;
		this.uname = uname;
		this.subject = subject;
		this.content = content;
		this.regtm = regtm;
		this.ip = ip;
		this.readcnt = readcnt;
		this.filename = filename;
		this.oriFilename = oriFilename;
		this.filesize = filesize;
	}
	public String getOriFilename() {
		return oriFilename;
	}
	public void setOriFilename(String oriFilename) {
		this.oriFilename = oriFilename;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
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
	public String getRegtm() {
		return regtm;
	}
	public void setRegtm(String regtm) {
		this.regtm = regtm;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
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
	public int getFilesize() {
		return filesize;
	}
	public void setFilesize(int filesize) {
		this.filesize = filesize;
	}
	
	
}
