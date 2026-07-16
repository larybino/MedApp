package bino.laryssa.backend.service;

import bino.laryssa.backend.model.enums.DoseInterval;

import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DoseIntervalMapper {

    private static final Map<Integer, DoseInterval> HOURS_TO_INTERVAL = Map.of(
            4, DoseInterval.FOUR_HOURS,
            6, DoseInterval.SIX_HOURS,
            8, DoseInterval.EIGHT_HOURS,
            12, DoseInterval.TWELVE_HOURS,
            24, DoseInterval.TWENTY_FOUR_HOURS
    );

    private static final Pattern HOURS_PATTERN = Pattern.compile("(\\d{1,2})\\s*h(?:oras?)?");

    private static final Pattern ONCE_A_DAY_PATTERN = Pattern.compile(
            "1\\s*x|uma vez|1 vez|diariamente|ao dia"
    );

    private DoseIntervalMapper() {
    }

    public static Optional<DoseInterval> map(String rawText) {
        if (rawText == null || rawText.isBlank()) {
            return Optional.empty();
        }

        String normalized = rawText.toLowerCase(Locale.forLanguageTag("pt-BR"));

        Matcher hoursMatcher = HOURS_PATTERN.matcher(normalized);
        if (hoursMatcher.find()) {
            int hours = Integer.parseInt(hoursMatcher.group(1));
            DoseInterval interval = HOURS_TO_INTERVAL.get(hours);
            if (interval != null) {
                return Optional.of(interval);
            }
            return Optional.empty();
        }

        if (ONCE_A_DAY_PATTERN.matcher(normalized).find()) {
            return Optional.of(DoseInterval.TWENTY_FOUR_HOURS);
        }

        return Optional.empty();
    }
}