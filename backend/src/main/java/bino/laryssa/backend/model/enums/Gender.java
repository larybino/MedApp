package bino.laryssa.backend.model.enums;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum Gender {
    MALE, FEMALE, OTHER;

    @JsonCreator 
    public static Gender from(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Gender.valueOf(value.trim().toUpperCase());
    }
}