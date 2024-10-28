

class MetadataPopup extends PApplet {

    public Boolean isVisible = false;

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
        println("MetadataPopup created.");
        surface.setTitle("Metadata");
        this.isVisible = true;
    }

    @Override
    void draw() {
    }

    @Override
    void mousePressed() {
        println("MetadataPopup : mouse pressed.");
    }

    @Override
    void mouseReleased() {
        println("MetadataPopup : mouse released.");
    }

    @Override
    void exit() {
        this.isVisible = false;
        println("MetadataPopup : exiting, hidding.");
    }

    public void hide() {
        surface.setVisible(false);
        this.isVisible = false;
        println("MetadataPopup : hidding.");
    }

    public void show() {
        surface.setVisible(true);
        this.isVisible = true;
        println("MetadataPopup : showing.");
    }

}
