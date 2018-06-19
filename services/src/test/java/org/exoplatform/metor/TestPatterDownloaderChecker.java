package org.exoplatform.metor;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.junit.Test;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

public class TestPatterDownloaderChecker {

	@Test
	public void test1() {
		System.out
				.println("********************** Test 1 *********************************");
		String prop1 = "/spaces/spaceta,/spaces/space_space,/spaces/space_w";
		System.out.println("the configured gatein Properties is:" + prop1);
		List<String> spacesDonwloadCheck = Arrays.asList(prop1.split(","));
		String path1 = "/Groups/spaces/space_w/Documents/Doc1.docx";
		System.out.println("the recieved Path is:" + path1);
		String groupPatern = StringUtils.substringAfter(path1,
				"/Groups/spaces/");
		String groupName = StringUtils.substringBefore(groupPatern, "/");
		String groupID = "/spaces/" + groupName;
		boolean hasdownload = spacesDonwloadCheck.contains(groupID);
		assertTrue(hasdownload);

		System.out.println("Test 1" + " has download right ?" + hasdownload);
	}

	@Test
	public void test2() {
		System.out
				.println("********************** Test 2 *********************************");
		String prop1 = "/spaces/spacex,/spaces/space_space,/spaces/space_w";
		System.out.println("the configured gatein Properties is:" + prop1);
		List<String> spacesDonwloadCheck = Arrays.asList(prop1.split(","));
		String path2 = "/Groups/spaces/spacex/Documents/platform-documentation-developer-5.0.pdf";
		System.out.println("the recieved Path is:" + path2);
		String groupPatern = StringUtils.substringAfter(path2,
				"/Groups/spaces/");
		String groupName = StringUtils.substringBefore(groupPatern, "/");
		String groupID = "/spaces/" + groupName;
		boolean hasdownload = spacesDonwloadCheck.contains(groupID);
		System.out.println("Test 2" + " has download right ?" + hasdownload);
		assertTrue(hasdownload);
	}

	@Test
	public void test3() {
		System.out
				.println("********************** Test 3 *********************************");
		String prop1 = "/spaces/spaceta,/spaces/space_space,/spaces/space_w,,";
		System.out.println("the configured gatein Properties is:" + prop1);
		List<String> spacesDonwloadCheck = Arrays.asList(prop1.split(","));
		String path3 = "/Groups/spaces/space_w/Documents/Doc1.docx";
		System.out.println("the recieved Path is:" + path3);
		String groupPatern = StringUtils.substringAfter(path3,
				"/Groups/spaces/");
		String groupName = StringUtils.substringBefore(groupPatern, "/");
		String groupID = "/spaces/" + groupName;
		boolean hasdownload = spacesDonwloadCheck.contains(groupID);
		System.out.println("Test 3" + " has download right ?" + hasdownload);
		assertTrue(hasdownload);
	}

	@Test
	public void test4() {
		System.out
				.println("********************** Test 4 *********************************");
		String prop1 = "";
		System.out.println("the configured gatein Properties is:" + prop1);
		List<String> spacesDonwloadCheck = Arrays.asList(prop1.split(","));
		String path3 = "/Groups/spaces/space_w/Documents/Doc1.docx";
		System.out.println("the recieved Path is:" + path3);
		String groupPatern = StringUtils.substringAfter(path3,
				"/Groups/spaces/");
		String groupName = StringUtils.substringBefore(groupPatern, "/");
		String groupID = "/spaces/" + groupName;
		boolean hasdownload = spacesDonwloadCheck.contains(groupID);
		System.out.println("Test 3" + " has download right ?" + hasdownload);
		assertFalse(hasdownload);
	}

	public void test5() {
		System.out
				.println("********************** Test 5 *********************************");
		String prop1 = "";
		System.out.println("the configured gatein Properties is:" + prop1);
		List<String> spacesDonwloadCheck = Arrays.asList(prop1.split(","));
		String path3 = "xxxx/Documents/Doc1.docx";
		System.out.println("the recieved Path is:" + path3);
		String groupPatern = StringUtils.substringAfter(path3,
				"/Groups/spaces/");
		String groupName = StringUtils.substringBefore(groupPatern, "/");
		String groupID = "/spaces/" + groupName;
		boolean hasdownload = spacesDonwloadCheck.contains(groupID);
		System.out.println("Test 3" + " has download right ?" + hasdownload);
		assertFalse(hasdownload);
	}

}
