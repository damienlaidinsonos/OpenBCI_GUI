
class MetadataPopup extends PApplet {
    private final String metadataLayoutFileName = "metadataLayout.csv";
    private final String metadataFieldsFileName = "metadataFields.json";
    private final String metadataFileName = "metadata.json";
    private final int spaceWidth = 25;
    private final int spaceHeight = 25;

    public Boolean isVisible = false;

    private ControlP5 cp5;
    // Location of the app data folder
    private String dataPath;
    private PFont font;
    private String sessionFolder;

    private final SortedMap<String, ScrollableList> dropdowns = new TreeMap<>();
    private final SortedMap<String, Button> buttons = new TreeMap<>();

    private Textlabel checkMarkLabel;

    public MetadataPopup(String dataPath, String sessionFolder) {
        super();
        PApplet.runSketch(new String[] {"Metadata"}, this);
        this.dataPath = dataPath;
        this.sessionFolder = sessionFolder;
    }

    @Override
    void settings() {
        size(300, 300);
    }

    @Override
    void setup() {
        surface.setTitle("Metadata");
        surface.setAlwaysOnTop(false);
        surface.setResizable(false);
        // textSize(18);
        this.isVisible = true;
        this.cp5 = new ControlP5(this);
        this.font = createFont("Georgia", 15);

        Path fieldsFilePath = Paths.get(this.dataPath, metadataFieldsFileName);
        JSONObject metadataFields = loadJSONObject(fieldsFilePath.toString());
        if (metadataFields == null) {
            new PopupMessage("File not found.", "Could not load " + fieldsFilePath.toString());
            return;
        }

        Path layoutFilePath = Paths.get(this.dataPath, metadataLayoutFileName);
        Table layout = loadTable(layoutFilePath.toString(), "header");
        if (layout != null) {
            for(TableRow row : layout.rows()) {
                String id = row.getString("ID");
                String uiType = row.getString("UIType");
                String label = row.getString("Label");
                float x = row.getFloat("X");
                float y = row.getFloat("Y");
                int w = row.getInt("Width");
                int h = row.getInt("Height");
                if (uiType.equals("dropdown")) {
                    JSONArray values = metadataFields.getJSONArray(label);
                    ScrollableList dropdown = createDropDown(id, values, x, y, w, h);
                    this.dropdowns.put(label, dropdown);
                } else if (uiType.equals("textfield")) {
                    createTextLabel(id, label, x, y, w, h);
                }
            }
        } else {
            new PopupMessage("File not found.", "Could not load " + layoutFilePath.toString());
        }

        final int buttonLen = 100;
        final String saveLabel = "save";
        final Button saveButton = createButton(saveLabel, saveLabel, 0, 0, buttonLen, this.spaceHeight);
        buttons.put(saveLabel, saveButton);

        checkMarkLabel = cp5.addTextlabel("checkMarkLabel")
            .setText("✔")
            .setSize(this.spaceHeight, this.spaceHeight)
            .setPosition(0, 0)
            .setFont(this.font)
            .setColorValueLabel(color(0, 255, 0))
        ;
        checkMarkLabel.setVisible(false);
    }

    @Override
    void draw() {
        background(200);

        Button saveButton = this.buttons.get("save");
        final int buttonWidth = saveButton.getWidth();
        int buttonX = width - this.spaceWidth * 3 - buttonWidth;
        int buttonY = height - 2 * this.spaceHeight;
        saveButton.setPosition(buttonX, buttonY);
        checkMarkLabel.setPosition(buttonX + saveButton.getWidth() + this.spaceWidth, buttonY);
    }

    @Override
    void exit() {
        this.isVisible = false;
    }

    public void hide() {
        surface.setVisible(false);
        this.isVisible = false;
    }

    public void show() {
        surface.setVisible(true);
        this.isVisible = true;
    }

    private ScrollableList createDropDown(String id, JSONArray values, float x,  float y, int w, int h) {
        ScrollableList list = cp5.addScrollableList(id)
            .setPosition(x, y)
            .setOpen(false)
            .setWidth(w)
            .setVisible(true)
            .setBarHeight(h)
            .setItemHeight(h)
            .setColorValueLabel(OPENBCI_DARKBLUE)
            .setColorCaptionLabel(OPENBCI_DARKBLUE)
            ;

        final int paddingTop = 4;

        list.getCaptionLabel()
            .toUpperCase(false)
            .setFont(this.font)
            .getStyle() //need to grab style before affecting the paddingTop
            .setPaddingTop(paddingTop)
            ;
        
        list.getValueLabel()
            .toUpperCase(false)
            .setFont(this.font)
            .getStyle() //need to grab style before affecting the paddingTop
            .setPaddingTop(paddingTop)
            ;

        for (int i = 0; i < values.size(); i++) {
            String value = values.getString(i); 
            list.addItem(value, value);
        }

        list.setValue(0);

        list.addCallback(new CallbackListener() {
            @Override
            public void controlEvent(CallbackEvent event) {
                if (event.getAction() == ControlP5.ACTION_CLICK) {
                    if (list.isOpen()) {
                        list.bringToFront();
                    }
                } else if (event.getAction() == ControlP5.ACTION_BROADCAST) {
                    // Action to do when an element is selected
                    checkMarkLabel.setVisible(false);
                }
            }
        });
        
        return list;
    }

    private void createTextLabel(String id, String label, float x, float y, int w, int h) {
        cp5.addTextlabel(id)
            .setText(label)
            .setPosition(x, y)
            .setSize(width, height)
            .setFont(this.font)
            .setColor(OPENBCI_DARKBLUE)
            ;
    }

    private Button createButton(String id, String label, float x, float y, int w, int h) {
        Button button = cp5.addButton(label)
            .setValue(0)
            .setPosition(x, y)
            .setSize(w, h)
            .setFont(this.font)
        ;

        button.addCallback(new CallbackListener() {
            @Override
            public void controlEvent(CallbackEvent event) {
                if (event.getAction() == ControlP5.ACTION_CLICK) {
                    JSONObject json = new JSONObject();

                    for (Map.Entry<String, ScrollableList> entry : dropdowns.entrySet()) {
                        final ScrollableList l = entry.getValue();
                        final int selectedIndex = int(l.getValue());
                        final String key = entry.getKey();
                        final String value = l.getItem(selectedIndex).get("value").toString();
                        json.setString(key, value);
                    }

                    Path destPath = Paths.get(sessionFolder, metadataFileName);
                    if (saveJSONObject(json, destPath.toString())) {
                        checkMarkLabel.setVisible(true);
                    } else {
                        println("Failed to save " + destPath.toString());
                    }
                }
            }
        });

        return button;
    }

}
