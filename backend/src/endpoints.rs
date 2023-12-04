use actix_web::{get, web, Responder};
use ts_rs::TS;
use ulid::Ulid;
use chrono::{NaiveDate};
use serde::Serialize;

// Request types
// #[derive(TS)]
// #[ts(export)]
// struct User {
//     user_id: i32,
//     first_name: String,
//     last_name: String,
// }

// Response types
#[derive(Serialize, TS)]
#[ts(export)]
#[serde(rename_all = "snake_case")]  // https://stackoverflow.com/a/59167858
enum PatchReason {
    Dryck,
    Event,
    Other
}
#[derive(Serialize, TS)]
#[ts(export)]
struct PatchResponse {
    #[ts(type = "string")]
    ulid: Ulid,

    name: String,

    release_date: NaiveDate,

    #[ts(type = "string")]
    organizer: Ulid,

    reason: PatchReason,

    #[ts(optional)]
    #[ts(type = "string")]
    event: Option<Ulid>,

    #[ts(type = "[string]")]
    pictures: Vec<Ulid>,

    #[ts(type = "[string]")]
    tags: Vec<Ulid>,

    #[ts(type = "[string]")]
    artists: Vec<Ulid>
}


// Endpoints
#[get("/")]
async fn index() -> impl Responder {
    "Hello, World!"
}

#[get("/{name}")]
async fn hello(name: web::Path<String>) -> impl Responder {
    format!("Hello {}!", &name)
}

fn generate_dummy_patch(ulid: String) -> PatchResponse {
    PatchResponse{
        ulid: Ulid::from_string(&ulid).unwrap_or(Ulid::new()),
        name: String::from("The best patch"),
        release_date: NaiveDate::from_ymd_opt(2023,1,1).unwrap(),
        organizer: Ulid::new(),
        reason: PatchReason::Dryck,
        event: None,
        pictures: vec![Ulid::new()],
        tags: vec![Ulid::new()],
        artists: vec![Ulid::new()]
    }
}

#[get("/patch/{ulid}")]
async fn get_patch(path: web::Path<String>) -> impl Responder {
    let ulid = path.into_inner();
    serde_json::to_string(&generate_dummy_patch(ulid)).unwrap()
}
