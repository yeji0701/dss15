# name : collection ??
db.createCollection("user1", {autoIndexId: true, capped: true, size: 500, max:5 })
db.createCollection("user2", {autoIndexId: true, capped: true, size: 50, max:5 })

# ??? ??? ??
show collections

# info ???? document ??
db.user1.insert({ "subject":"python", "level":3 })
db.user1.insert({ "subject":"web", "level":1 })
db.user1.insert({ "subject":"sql", "level":2 })

# max:5 ?? ??? ?? ?? ??? 5?? user1? ???? ? ?? ??? ??? ????.
db.user1.insert([
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    { "subject":"sql", "level":2 },
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    { "subject":"sql", "level":2 },
    ])
    
# size:50 ?? ??? ?? ?? ??? 4? user2? ????.
db.user2.insert( [
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    { "subject":"sql", "level":2 },
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    ])

db.info.insert( [
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    { "subject":"sql", "level":2 },
    { "subject":"python", "level":3 },
    { "subject":"web", "level":1 },
    { "subject":"sql", "level":2 },
    ])
    
# level2? ??? ?? : ????? ???? ???? ????? ??? ????.
db.info.remove({level:2})

# db.collection.find(query, projection)
# query : where ?
# projection : ???? field, select

# query
db.info.find()
# subject? python? document ??
db.info.find({"subject": "python"})
## ?? ???
# level? 2 ??? document? ??
db.info.find({"level": {$lte: 2} })
# level? 3 ??? document? ??
db.info.find({"level": {$gte: 3} })
## ?? ???: $ $and, $not, $nor
# subject? python?? level? 4??? document ??
db.info.find({$and: [{"subject":"python"}, {"level": {$gte: 3}}]})
# subject? python???? level? 1??? ?? document ??
db.info.find({$nor: [{"subject":"python"}, {"level": {$lte: 1}}]})
## where
# level? 1? document ??
db.info.find({$where: "this.level == 1"})

# projection
# subject? comments? ????? find
# ??? true ?? ????? false ?? ?????. ( _id? ?? ??? ??? true )
db.info.find({},{"_id":false, "level":false})
db.info.find({},{"subject":true, "level":true})
db.info.find({},{"_id":false, "subject":true, "level":true})

# sort
db.info.find().sort({"level":1})
db.info.find().sort({"level":-1})
db.info.find().sort({"level":-1, "subject":1})

# limit:  mysql? limit? ?? ???? ????.
db.info.find().limit(3)
# level? ?????? ???? 3???? ??
db.info.find().sort({"level":-1}).limit(3)
# 3?? ?? ??
db.info.find().skip(2)

# upsert: ??? ??? update, ??? insert
# ????? ??? ??????, ???? multi:true
db.info.update(
    {"subject": "html" },
    {"subject": "sass", "level":2}
    )
    
db.info.update(
    {"subject": "less" },
    {"subject": "less", "level":2},
    {"upsert":true}
    )
    
# set
db.info.update(
    {level: 2},
    {$set: {level: 1}},
    {multi: true}
    )
    
# function
var showSkip = function(start){
    return db.info.find().skip(start-1)
}
showSkip(2)