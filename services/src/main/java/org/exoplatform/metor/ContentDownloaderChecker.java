package org.exoplatform.metor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.lang.StringUtils;
import org.exoplatform.services.log.ExoLogger;
import org.exoplatform.services.log.Log;
import org.exoplatform.services.organization.OrganizationService;
import org.exoplatform.services.rest.resource.ResourceContainer;
import org.exoplatform.services.security.ConversationState;
import org.exoplatform.services.security.Identity;
import org.exoplatform.social.core.space.model.Space;
import org.exoplatform.social.core.space.spi.SpaceService;
import org.json.JSONObject;

@Path("/metor")
public class ContentDownloaderChecker implements ResourceContainer {

	private static final Log LOG = ExoLogger
			.getLogger(ContentDownloaderChecker.class);
	private SpaceService spaceService_;
	private ContentDownloaderCheckerConfig contentDownloaderCheckerConfig_;

	public ContentDownloaderChecker(OrganizationService organizationService,
			SpaceService spaceService,ContentDownloaderCheckerConfig contentDownloaderCheckerConfig) {
		this.spaceService_ = spaceService;
		contentDownloaderCheckerConfig_=contentDownloaderCheckerConfig;
	}

	// downloadUrl"/portal/download?resourceId=677079670"
	// openUrl
	// "/portal/g/:spaces:spacex/spacex/documents?path=Groups%2FGroups%2Fspaces%2Fspacex%2FDocuments%2Fplatform-documentation-developer-5.0.pdf&groupId=/spaces/spacex"
	// path
	// "/Groups/spaces/spacex/Documents/platform-documentation-developer-5.0.pdf"

	@GET
	@Path("checkurl")
	public Response getConfig(@Context HttpServletRequest request,
			@Context HttpServletResponse response,
			@QueryParam("path") String path) throws Exception {

		JSONObject json = new JSONObject();
		Identity currentUser = ConversationState.getCurrent().getIdentity();
	  List<String> spaceListCheck = contentDownloaderCheckerConfig_.getspacesCategories();
		  json.put("hasdownload", true);
		  try {
		  String groupPatern = StringUtils.substringAfter(path, "/Groups/spaces/");
	      String groupName = StringUtils.substringBefore(groupPatern, "/");
	      String groupID="/spaces/"+groupName;
			if (!StringUtils.isEmpty(path)) {
				Space s = spaceService_.getSpaceByGroupId(groupID);
				if (s != null && !spaceListCheck.isEmpty() && spaceListCheck.contains(groupID) ) {
					if (!currentUser.isMemberOf(groupID, "download")) {
						LOG.info("currentUser : " + currentUser.getUserId()
								+ " is Manager of " + groupID
								+ " -> hiding download button.");
						json.put("hasdownload", false);
						return Response.ok(json.toString(),
								MediaType.APPLICATION_JSON).build();

					}

				}

			}

		} catch (Exception e) {
			e.printStackTrace();

		}
		return Response.ok(json.toString(), MediaType.APPLICATION_JSON).build();

	}

}
