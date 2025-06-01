native func LogChannel(channel: CName, const text: script_ref<String>)

@addField(MinimapContainerController)
let m_geometryCache: wref<inkCacheWidget>;

// stashing the north-fixed copy here
@addField(MinimapContainerController)
let m_geometryCacheNorthed: wref<inkCacheWidget>;

@addMethod(MinimapContainerController)
func ToggleMinimaps() {
  if this.m_geometryCache.IsVisible() {
    this.m_geometryCache.SetVisible(false);
    this.m_geometryCacheNorthed.SetVisible(true);
    LogChannel(n"DEBUG", s"MinimapContainerController: m_geometryCache was visible, setting it to not visible");
    //LogWidgetTree(n"DEBUG", (this.m_rootWidget as inkCompoundWidget), true);
  } else {
    this.m_geometryCacheNorthed.SetVisible(false);
    this.m_geometryCache.SetVisible(true);
    LogChannel(n"DEBUG", s"MinimapContainerController: m_geometryCache was not visible, setting it to visible");
  }
}

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  LogChannel(n"DEBUG", s"MinimapContainerController: initialized!");
  GameInstance.GetCallbackSystem()
    .RegisterCallback(n"Input/Key", this, n"OnKeyInput", true)
    .AddTarget(InputTarget.Key(EInputKey.IK_L))
    .SetLifetime(CallbackLifetime.Session);
  let rootWidget_canvas = this.m_rootWidget as inkCanvas; 
  this.m_geometryCache = rootWidget_canvas.GetWidgetByPathName(n"MiniMapContainer/maskedContainer/geometryCache") as inkCacheWidget;
  this.m_geometryCacheNorthed = SpawnFromLocal(rootWidget_canvas, n"Root");
  this.m_geometryCacheNorthed.SetTintColor(new HDRColor(0.5, 1.0, 0.5, 0.5));
  // let MiniMapContainer = rootWidget_canvas.GetWidget(n"MiniMapContainer") as inkCanvas;
  // let maskedContainer = MiniMapContainer.GetWidget(n"maskedContainer") as inkCanvas;
  // this.m_geometryCache = maskedContainer.GetWidget(n"geometryCache") as inkCacheWidget;
}

@addMethod(MinimapContainerController)
private cb func OnKeyInput(evt: ref<KeyInputEvent>) {
  this.ToggleMinimaps();
  LogChannel(n"DEBUG", s"MinimapContainerController: service got event, key pressed: \(evt.GetKey()).");
}


public func LogWidgetTree(channel: CName, widget: wref<inkCompoundWidget>, opt props: Bool, opt indent: String) {
  let i = 0;

  if StrLen(indent) == 0 {
    LogChannel(channel, s"\(widget.GetName()) - \(widget.GetClassName())");
  }

  let controllers = widget.GetControllers();
  for c in controllers {
    LogChannel(channel, s"\(indent)  controller: \(c.GetClassName())");
  }
  let userdata = widget.userData;
  for d in userdata {
    LogChannel(channel, s"\(indent)  user data, class: \(d.GetClassName()), content: \(d)");
  }

  while i < widget.GetNumChildren() {
    let child: wref<inkWidget> = widget.GetWidget(i);
    let compChild = child as inkCompoundWidget;

    LogChannel(channel, s"\(indent)|-- \(child.GetName()) - \(child.GetClassName())");

    let controllers = child.GetControllers();
    for c in controllers {
      LogChannel(channel, s"\(indent)  controller: \(c.GetClassName())");
    }
    let userdata = child.userData;
    for d in userdata {
      LogChannel(channel, s"\(indent)  user data, class: \(d.GetClassName()), content: \(d)");
    }

    if props {
      let anchor = child.GetAnchor();
      let size = child.GetSize();
      let scale = child.GetScale();
      let rotation = child.GetRotation();

      LogChannel(channel, s"\(indent)  anchor: inkEAnchor.\(anchor)");
      LogChannel(channel, s"\(indent)  size: (\(size.X), \(size.Y))");
      LogChannel(channel, s"\(indent)  scale: (\(scale.X), \(scale.Y))");
      LogChannel(channel, s"\(indent)  rotation: (\(rotation))");

      let wText = child as inkText;

      if IsDefined(wText) {
        LogChannel(channel, s"\(indent)  text: \"\(wText.GetText())\"");
        LogChannel(channel, s"\(indent)  fontSize: \"\(wText.GetFontSize())\"");
      }
    }
    if IsDefined(compChild) {
      LogWidgetTree(channel, compChild, props, s"\(indent)    ");
    }
    i += 1;
  }
}