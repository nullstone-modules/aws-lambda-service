locals {
  dead_letter_queues = merge(flatten([
    for mod in local.cap_modules : {
      for item in lookup(mod.outputs, "dead_letter_queues", []) : item.queue_arn => item
    }
  ])...)
}
