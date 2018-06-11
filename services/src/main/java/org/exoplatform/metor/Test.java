package org.exoplatform.metor;

import java.net.MalformedURLException;

import org.apache.commons.lang.StringUtils;

public class Test {

	public static void main(String[] args) throws MalformedURLException {
		String s="Groups/spaces/spacex/Documents/registre-reglement-Blog.xlsx";
		try {
      String groupPatern = StringUtils.substringAfter(s, "Groups/spaces/");
      String groupName = StringUtils.substringBefore(groupPatern, "/");
      System.out.print(groupName);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
		

	}

}
