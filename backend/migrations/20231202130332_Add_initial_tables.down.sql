-- Add down migration script here
DROP TABLE countries,
    cities,
    universities,
    studentkar,
    studentkar_sektioner,
    foreningar,
    nationer,
    namnder,
    organizers,
    events,
    event_occurrences,
    patches,
    patch_tags,
    patch_tags_relations,
    patch_pictures,
    patch_artists,
    patch_artists_relations;

DROP TYPE namnd_type, patch_reason;
