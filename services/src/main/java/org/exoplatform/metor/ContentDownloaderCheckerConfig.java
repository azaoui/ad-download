package org.exoplatform.metor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.exoplatform.commons.utils.PropertyManager;
import org.exoplatform.container.component.BaseComponentPlugin;
import org.exoplatform.container.xml.InitParams;

/**
 * @author azaoui@exoplatform.com
 */
public class ContentDownloaderCheckerConfig extends BaseComponentPlugin {

  private List<String>        spacesDonwloadCheck = new ArrayList<String>();

  private static final String DOWNLOAD_LIST  = "metor.spaces.download.check";

  public ContentDownloaderCheckerConfig(InitParams initParams) {

    String categories = StringUtils.isNotBlank(PropertyManager.getProperty(DOWNLOAD_LIST)) ? PropertyManager.getProperty(DOWNLOAD_LIST)
                                                                                            : initParams.getValueParam("spaces-download-check")
                                                                                                        .getValue();

    spacesDonwloadCheck = Arrays.asList(categories.split(","));

  }

  public List<String> getspacesCategories() {
    return spacesDonwloadCheck;
  }

}