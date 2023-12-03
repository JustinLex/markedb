use actix_web::{App, HttpServer};

mod endpoints;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(endpoints::index)
            .service(endpoints::hello)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
