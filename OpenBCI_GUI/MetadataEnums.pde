
public interface MetadataEnumInterface {
    String getString();
}

public enum SignalType implements MetadataEnumInterface {
    UNSPECIFIED("UNSPECIFIED"),
    ECG("ECG"),
    EEG("EEG"),
    EMG("EMG"),
    EOG("EOG");

    private final String string;
    private static final SortedMap<MetadataEnumInterface, String> items = new TreeMap<>();

    static {
        for (SignalType signalType : SignalType.values()) {
            items.put(signalType, signalType.getString());
        }
    }
 
    SignalType(String string) {
        this.string = string;
    }
 
    @Override
    public String getString() {
        return this.string;
    }

    static Map<MetadataEnumInterface, String> getItems() {
        return items;
    }
}
