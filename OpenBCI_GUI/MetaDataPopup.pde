
class MetadataPopup extends PApplet {

    public Boolean isVisible = false;

    private ControlP5 cp5;

    private ScrollableList signalTypeDropDown;
    private int selectedSignalIndex;

    public MetadataPopup() {
        super();
        PApplet.runSketch(new String[] {"Metadata"}, this);
    }

    @Override
    void settings() {
        size(600, 600);
    }


    @Override
    void setup() {
        surface.setTitle("Metadata");
        surface.setAlwaysOnTop(false);
        surface.setResizable(true);
        textSize(18);
        this.isVisible = true;

        this.cp5 = new ControlP5(this);
        this.signalTypeDropDown = createDropDown(SignalType.getItems(), "SignalType", 100.0, 100.0, 200, 100);

    
    }

    @Override
    void draw() {
        background(200);
        text("selectedSignalIndex : " + selectedSignalIndex, 20, 20);
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

    private ScrollableList createDropDown(Map<MetadataEnumInterface, String> items, String name, float x,  float y, int width, int height) {
        ScrollableList list = cp5.addScrollableList(name)
            .setPosition(x, y)
            .setOpen(false)
            .setSize(width, height)
            .setVisible(true)
            .setBarHeight(20)
            .setItemHeight(20)
            ;

        for (Map.Entry<MetadataEnumInterface, String> entry : items.entrySet()) {
            list.addItem(entry.getValue(), entry.getKey());
        }

        list.setValue(0);

        list.addCallback(new CallbackListener() {
            @Override
            public void controlEvent(CallbackEvent event) {
                if (event.getAction() == ControlP5.ACTION_BROADCAST) {
                    println("ACTION_BROADCAST Event triggered ");
                    int selectedIndex = int(list.getValue());
                    dropDownAssignSelectedIndex(name, selectedIndex);
                }
            }
        });
        
        return list;
    }

    private void dropDownAssignSelectedIndex(String name, int selectedIndex) {
        switch (name) {
            case "SignalType":
                selectedSignalIndex = selectedIndex;
                break;
            default:
                println("Unhandled dropdown name : " + name);
        }
    }

}
