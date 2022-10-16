# Draft - Initial Page: On-call Response

There are few pieces of incident response as important as the on-call team
member.  They are the first to be alerted, directly, to an incident.  The
actions they take within the first moments of an incident can set the pace of
events to a fast recovery or delay events with costly results.

It is vital for the on-call team member to be setup for success.  Proper
documentation, play-books, tools, and policy need to be in place to ensure the
on-call team member have what they need.  Assuming all of those pieces are
there, let's take a look at the first few moments of on-call response.

## The first five minutes:

Delay can be found everywhere in incident response, even in the technology we
use to monitor our applications.  For example, the monitor thresholds could be
set too high and a problem that should have been caught sooner is now a
cascading disaster in progress.  There are delays between the monitoring
systems, the alerts they fire, and the delivery of those alerts to on-call
responders.  It can be common for alerting systems to hold fresh alerts for a
few short minutes before paging a responder on systems that frequently
self-heal.  Sometimes the source of the alerts is a downstream system that has
monitoring and is only alerting after several unmonitored upstream systems have
failed silently.  Finally, not all organizations will leverage real-time
communication options such as SMS delivery or mobile pushes and email can be
slow.

With all these possibilities in consideration it can be safe to assume any alert
a responder receives could already be several minutes old.  This makes the next
five minutes the alert is in the hands of the responder critical to avoiding
even further delay.  In this small amount of time the responder will need to
review the alert, make an initial approximation of its severity, and set the
wheels in motion for any recovery steps needed.  To complicate their task, there
could be multiple alerts paging them all at once.

In order stand in the eye of an alert storm, when hundreds of alerts are paging
dozens of team members, without giving into panic one must have patiences,
focus, practice, and a goal.  So what should the first five, or less, minutes
look like?  Let's break it down into a few direct questions that guide a
responder through these critical minutes.

!!! caution "Assumption"

    We're assuming a lot here that hasn't been mentioned, including that the alert
    has arrived to the correct person. All the planning in the world doesn't help if
    the alert delivered is not meaningful and actionable *by the responder*
    receiving it.

### Are you available? Choosing when to escalate.

Draft points:

* Driving, bathroom, otherwise will be delayed
* Escalation paths and options
* Knowing how long an ignored alert will wait
* Having options

### What is broken? Ignoring the noise.

Draft points:

* Alert storms: seeing through the noise
* Having awareness of the landscape
* Identifying systems, applications, and triage

### How broken is it? Handling implied urgency.

Draft points:

* A glimpse into the metrics
* Knowing the "worst-case" alerts
* Runbooks or play-books for identifying the severity
* Dozens of alerts does not equal disaster
* One alert does not equal safety

### Can you handle it? When more eyes are better.

Draft points:

* Revisit to escalation options
* Upstream system? Get that on-call involved asap
* When in doubt, ask
* Waking up extra eyes for a false alarm is better than finding system in
  smoldering ruins the next morning
