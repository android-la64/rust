use crate::setup::{ParDatabase, ParDatabaseImpl};

#[test]
#[should_panic]
fn snapshot_from_query() {
    let db = ParDatabaseImpl::default();
    db.snapshot_me();
}
