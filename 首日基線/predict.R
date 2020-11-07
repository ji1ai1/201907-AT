#R version 3.6.1 (2019-07-05) -- "Action of the Toes"
#R package data.table 1.12.2
#
#0.1606
library(data.table)

Testing = fread("Antai_AE_round1_test_20190626.csv")
Testing$si = as.double(as.POSIXct(Testing$create_order_time)) - as.double(as.POSIXct("2018-09-01"))

Items = Testing[, .(item_nrecords = .N), .(item_id)][order(-item_nrecords)]

Prediction = Testing[, .(score = sum(1 / (si / 86400) ** 64)), .(buyer_admin_id, item_id)]
Prediction = Prediction[order(-score)]
Prediction = Prediction[, .(item_id = unique(c(item_id, Items$item_id[1:30]))[1:30]), .(buyer_admin_id)]
Prediction = Prediction[, .(prediction_string = paste(item_id, collapse ="," )), .(buyer_admin_id)]
write.table(Prediction, "result.csv", sep = ",", quote = F, row.names = F, col.names = F)
