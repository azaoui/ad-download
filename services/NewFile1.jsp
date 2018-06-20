<%
  import java.net.URLEncoder;
  import javax.jcr.PathNotFoundException;
  
  import org.exoplatform.ecm.webui.utils.Utils ;
  import org.exoplatform.web.application.Parameter ;
  import org.exoplatform.webui.core.UIRightClickPopupMenu ;
  import org.exoplatform.ecm.webui.component.explorer.UIWorkingArea;
  import org.exoplatform.ecm.utils.text.Text;
  import org.exoplatform.ecm.jcr.model.Preference;
  import org.exoplatform.ecm.webui.component.explorer.UIJCRExplorer;
  import org.exoplatform.services.cms.link.LinkManager;  
  import org.exoplatform.services.jcr.RepositoryService; 
  import org.exoplatform.services.wcm.utils.WCMCoreUtils;
  import org.exoplatform.services.cms.thumbnail.impl.ThumbnailUtils;
  import org.exoplatform.services.cms.thumbnail.ThumbnailService;
  import org.exoplatform.portal.application.PortalRequestContext;
  import org.exoplatform.portal.webui.util.Util;
  import org.exoplatform.social.core.space.spi.SpaceService;
  import org.exoplatform.social.core.space.model.Space;
  import org.exoplatform.services.security.ConversationState;
  import org.exoplatform.services.security.Identity;
  import org.exoplatform.metor.ContentDownloaderCheckerConfig;
  import org.apache.commons.lang.StringUtils;
  
  def linkManager = WCMCoreUtils.getService(LinkManager.class);
  def spaceService = WCMCoreUtils.getService(SpaceService.class);
  def uiWorkingArea = uicomponent.getAncestorOfType(UIWorkingArea.class);
  def uiExplorer = uicomponent.getAncestorOfType(UIJCRExplorer.class);
  def pref = uiExplorer.getPreference();
  def enableDragAndDrop = pref.isEnableDragAndDrop();
  
  def uiCustomActionComponent = uiWorkingArea.getCustomAction();
  def managersMultiItemContext =  uiWorkingArea.getMultiActionsExtensionList();
  def managersGroundContext = uiWorkingArea.getGroundActionsExtensionList();
  
  def action = "";
  def permLinkComponent = null;
  
  UIRightClickPopupMenu contextMenu = uicomponent.getContextMenu() ;
  String componentId = uicomponent.getId();
  String portalName = uicomponent.getPortalName();
  RepositoryService rService = uicomponent.getApplicationComponent(RepositoryService.class);
  String repository = rService.getCurrentRepository().getConfiguration().getName();  
  String restContextName = Utils.getRestContextName(portalName);
  String serverUrl= uicomponent.getWebDAVServerPrefix();
  PortalRequestContext portalRequestContext = Util.getPortalRequestContext();
  String requestURL = portalRequestContext.getRequest().getRequestURL().toString();
  def spaceDwnloadCheckService = WCMCoreUtils.getService(ContentDownloaderCheckerConfig.class);
  List<String> spaceListCheck = spaceDwnloadCheckService.getspacesCategories();
  
  boolean isInSpaceListCheck=false;
  boolean isSpace = false;
  boolean hasDownloadRole = false;
  
  def size = uicomponent.getChildrenList().size();
  def viewComponentId  = new Date().getTime();
  def rcontext = _ctx.getRequestContext() ;
  def jsManager = rcontext.getJavascriptManager();
  jsManager.require("SHARED/ecm-utils", "ecmutil").
            require("SHARED/uiSimpleView", "uiSimpleView").
            require("SHARED/multiUpload", "multiUpload").
  addScripts("uiSimpleView.UISimpleView.initAllEvent('${componentId}-$viewComponentId', '$enableDragAndDrop');").
  addScripts("uiSimpleView.UISimpleView.loadImageOnSuccess();");
  
%>
<div id="$componentId">
<script language="JavaScript">
  function loadImageOnError(objImage) {
    var tryCount = objImage.getAttribute("retryCount");
    if (tryCount ==null) return;
    tryCount = parseInt(tryCount);
    if (tryCount>15) return;
    tryCount++;
    if (eXo.ecm.UISimpleView != null && objImage != null) {
      if (objImage.parentNode != null && objImage.parentNode.parentNode != null)
        eXo.ecm.UISimpleView.errorCallback(objImage.parentNode.parentNode);
    }else {
      objImage.setAttribute("retryCount", tryCount);
      setTimeout(function(){loadImageOnError(objImage)},300);
    }
  }
  
</script>
	<div id="${componentId}-$viewComponentId">
		<div style="position: relative; top: 0px; left: 0px; width: 0px; height: 0px">
			<div class="JCRMoveIcon" style="display: none;"><div class="MoveNode"><span>{number}</span></div></div>
			<div class="Mask" style="position: absolute; top: 0px; left: 0px; width: 0px; height: 0px"></div>
			<div class="JCRMoveAction" style="display: none;" request="<%=uiWorkingArea.getJCRMoveAction().event(UIWorkingArea.MOVE_NODE)%>" symlink="<%=uiWorkingArea.getCreateLinkAction().event(UIWorkingArea.CREATE_LINK)%>"></div>
			<div class="ItemContextMenu" style="position: absolute;	top: 0px; display: none;" >
				<div class="uiRightClickPopupMenu" style="display: block;">
					<ul class="dropdown-menu uiRightPopupMenuContainer" onmousedown="event.cancelBubble = true;" onkeydown="event.cancelBubble = true;">		
						<%
							for(itemContext in managersMultiItemContext) {
								action = itemContext.getUIExtensionName();
						%>
						<li class="menuItem" style="display: block;"> 	
							<a onclick=eXo.ecm.UISimpleView.postGroupAction("<%=itemContext.event(action)%>")>
								<i class="uiIconEcms${action}"></i> <%=_ctx.appRes("ECMContextMenu.event." + action)%>
							</a>
						</li>
						<%
							}
						%>
					</ul>	
				</div>
			</div>
			
			<div class="groundContextMenu" style="position: absolute;	top: 0px; display: none;">
					<div class="uiRightClickPopupMenu" style="display: block;">
						<ul class="dropdown-menu uiRightPopupMenuContainer" onmousedown="event.cancelBubble = true;" onkeydown="event.cancelBubble = true;">									
							<%
								for(itemGroundContext in managersGroundContext) {
								action = itemGroundContext.getUIExtensionName();
								def actionClick = "Upload".equals(action) ? "eXo.ecm.MultiUpload.uploadByRightClick()" : itemGroundContext.event(action);
							%>
							<li class="menuItem" style="display: block;"> 	
							<a onclick="<%=actionClick%>" href="javascript:void(0)">
									<i class="uiIconEcms${action}"></i> <%=_ctx.appRes("ECMContextMenu.event." + action)%>
								</a>
							</li>
							<%}%>			
						</ul>	
					</div>
			</div>
		</div>
		<div class="uiThumbnailsView $componentId">
		  <div class="actionIconsContainer clearfix">
		    <%
		      int i = 0;
		      def permlink;
		      for(data in uicomponent.getChildrenList()) {
    	        try {
    	          data.getSession().getItem(data.getPath());
    	        } catch(PathNotFoundException pne) {
    	          continue;
    	        }
    	        org.exoplatform.services.jcr.impl.core.NodeImpl thumbnailNode = uicomponent.getThumbnailNode(data);
    	        String time = System.currentTimeMillis(); //thumbnailNode dont have THUMBNAIL_LAST_MODIFIED property right after upload image
    	        if(thumbnailNode != null && thumbnailNode.hasProperty(ThumbnailService.THUMBNAIL_LAST_MODIFIED)){
    	        	time = thumbnailNode.getProperty(ThumbnailService.THUMBNAIL_LAST_MODIFIED).getDate().getTime();
    	        }
              i++;
		          def isPreferenceNode = uicomponent.isPreferenceNode(data) ;
		          def preferenceWS = data.getSession().getWorkspace().getName() ;
		          String name = data.getPath().substring(data.getPath().lastIndexOf("/") + 1) ;
              String title = uiWorkingArea.getTitle(data);              
		          String nodePath = data.getPath();
		          String actionLink = uicomponent.event("ChangeNode", Utils.formatNodeName(data.path), new Parameter("workspaceName", preferenceWS));
		          String strActs = "<li class=\"RightClickCustomItem\" style=\"display: none;\">";
		          strActs += "<ul>";
		          //Begin permlink
		          permLinkComponent =  uiWorkingArea.getPermlink(data);
		          if (permLinkComponent != null) {
		            permlink = permLinkComponent.getUIExtensionName();
		            strActs +=  "<li class='menuItem'>";
		            strActs +=  "<a exo:attr='ViewDocument' style='display: block;' href=\"" + permLinkComponent.getPermlink(data) + "\" target='_new' onclick=\"return eXo.ecm.WCMUtils.hideContextMenu(this);\">" ;
		            strActs +=  " <i class='uiIconEcmsViewDocument uiIconEcmsLightGray'> ";
		            strActs +=  " </i> ";
                strActs +=    _ctx.appRes("ECMContextMenu.event." + permlink);
		            strActs +=  "</a>";
		            strActs +=  "</li>";
		          }   
              List customActs = uicomponent.getCustomActions(data) ;
              Parameter[] params  ;
              if(customActs.size() > 0) {            
                for(act in customActs) {
                  String actName = act.getProperty("exo:name").getValue().getString() ;
                  params = [new Parameter("workspaceName", preferenceWS), new Parameter("actionName",act.getName())] ;
                  strActs +=  "<li class='menuItem'>";
                  strActs += "<a exo:attr=\"" +  Utils.getNodeTypeIcon(act,"") + "\" style='display: block;' onclick=\"return eXo.webui.UIRightClickPopupMenu.prepareObjectId(event, this);\" href=\"" + uiCustomActionComponent.event("Custom",Utils.formatNodeName(nodePath),params) + "\">" ;
                  strActs += "  <i class=\"" + Utils.getNodeTypeIcon(act, "uiIconEcms") + "\"></i> $actName" ;
                  strActs += "</a>" ;
                  strActs += "</li>";                  
                  }            
                }
              if (!data.isNodeType(Utils.EXO_RESTORELOCATION) && !Utils.isTrashHomeNode(data)) {  
              	String clipboardLink = serverUrl + "/" + restContextName + "/private/jcr/" + repository + "/" + preferenceWS + data.getPath();
              	
                if(requestURL.contains(":spaces:") || data.getPath().contains("/Groups/spaces/")){
                    isSpace=true;
                  }
                  if(isSpace){
                	  String groupPatern = StringUtils.substringAfter(data.getPath(),
              				"/Groups/spaces/");
              		String groupName = StringUtils.substringBefore(groupPatern, "/");
              		String groupID = "/spaces/" + groupName;  
                    Identity currentUser = ConversationState.getCurrent().getIdentity() ;
                    if(currentUser.isMemberOf(groupID,"download")) {
                  	  hasDownloadRole=true;
                      System.out.println("----------------------->Has Role Download");
                    }
                    if(!spaceListCheck.isEmpty() && spaceListCheck.contains("/spaces/"+spaceName)){
                      isInSpaceListCheck=true;
                      System.out.println("----- from thumbnails"+isInSpaceListCheck);
                    }
                  }
                  
                  boolean canViewDownload =true;
                  if(isSpace && isInSpaceListCheck && !hasDownloadRole)
                  canViewDownload=false;
              	
              	
              	if(canViewDownload){
              	strActs +=  "<li class='menuItem'>";
              	strActs +=  "<a exo:attr='CopyUrlToClipboard' style='display: block;' id='clip_button1$i' path='$clipboardLink'>" ;
              
              	strActs +=  " <i class='uiIconEcmsCopyUrlToClipboard uiIconEcmsLightGray'>";
              	strActs +=  " </i> " ;
              	strActs +=    _ctx.appRes("ECMContextMenu.event.GetURL");
          	    strActs +=  "</a>";
              	strActs += "</li>";
              	}
              }
              strActs += "</ul></li>" ;
                
              Boolean isLocked = false;
              String lockedLabel = "";
              String hiddenStyle = (data.isNodeType("exo:hiddenable"))?"color: #A0A0A0;":"";
              if (data.isLocked()) {
                isLocked = true;
                lockedLabel  = "("+_ctx.appRes("UIDocumentWorkspace.tooltip.LockedBy")+" "+data.getLock().getLockOwner()+")";
              }
		        %>   
		      <div class="actionIconBox" <%= uicomponent.getNodeAttributeInView(data) %> 
	       													   onclick="$actionLink">
		        <div style="height: auto; width: auto; border: none; -moz-user-select: none;" unselectable="on">
							<div class="nodeLabel">
								<div class="thumbnailImage">
                  <%
                    def encodedPath = URLEncoder.encode(Utils.formatNodeName(data.getPath()), "utf-8");
                    encodedPath = encodedPath.replaceAll ("%2F", "/");    //we won't encode the slash characters in the path
                    
									  String thumbnailImage = "/" + portalName + "/" + restContextName + "/thumbnailImage/medium/" + repository + "/" + preferenceWS + encodedPath;
									  if(!"".equals(time)) thumbnailImage = thumbnailImage + "?" + time;
									%>
									<div class="loadingProgressIcon" style="display: block;">
											<%if(isLocked) {%>
                        <div class="IconLocked"></div>
                      <%}%>
											<%if(uicomponent.isSymLink(data)) {%>
												<div class="Link"></div>
											<%}%>
											<div class="bgThumbnailImage" >
												<div style="background-image:url($thumbnailImage);">
												<img src="$thumbnailImage" retryCount="0"  onerror='loadImageOnError(this);' />
												</div>
											</div>
									</div>
							    
							    <div style="display: none;" class="<%=Utils.getNodeTypeIcon(data, "uiIcon64x64")%>">
                      <%if(isLocked) {%>
                        <div class="IconLocked"></div>
                      <%}%>
							      	<%if(uicomponent.isSymLink(data)) {%>
							          <div class="Link"></div>
							        <%}%>
							    </div>
								</div>
							</div>
			        <div class="actionIconLabel" rel="tooltip" data-placement="bottom" title="<%=title%> $lockedLabel">
			          <a class="actionLabel" style="$hiddenStyle"><span class="nodeName"><%=title%></span></a>
			        </div>
			      </div>
			      $strActs
		      </div>
		    <%}%>
		    
		  </div>  
		</div>
	</div>	
	<%
	 //re-initialize action
    uiWorkingArea.initialize();
	  int availablePage = uicomponent.getContentPageIterator().getAvailablePage();
	  if (availablePage > 1) { 
	%>	
		<div class="PageAvailable" pageAvailable='$availablePage'>
			<%_ctx.renderUIComponent(uicomponent.getContentPageIterator())%>
		</div>
	<% } %>
</div>