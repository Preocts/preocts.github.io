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

First and foremost, the immediate question that should be asked when the pager
goes off is if you are in a position to properly and safely respond.  Have
alternative escalation paths, other team members to call or text, on your phones
favorites list.  Know what happens with the on-call process your organization
uses when the primary on-call isn't available and be prepared to expedite that
process.  Nobody really wants to be the one that couldn't answer the call but
life happens.  Being the one that quickly pushed the call to the next available
team member, cutting the delays in the response time, is certainly better than
holding onto an alert or, worse, ignoring one.

This question should also be considered before your on-call shift, if possible,
to help make the choice quickly when you inevitably need to. Think about the
average activities in a day that would prevent you from responding in a timely
or safe manner and plan how to handle that situation.  If you're driving, is
there a way to quickly route the page to another team member?  Can you setup
covers for planned events that would prevent your response?

This question doesn't mean you are planning to kick the can down to the next
person.  It is just planning for the perfect storm situation that could catch
you completely unable to response.  In a health on-call culture you should feel
empowered to make this choice knowing that nobody is alone on a team.

!!! tip "Takeaway"

    Use your best judgment in the moment to make the choice on acknowledging the
    page or escalating it.  Do not put yourself at risk if you are in a situation
    that requires your attention elsewhere.  Have knowledge of how your organization
    handles on-call escalation.

### What is broken? Ignoring the noise.

There is a superstitious belief that bad news comes in threes.  Unfortunately,
with the power of technology and a poorly tuned monitoring system the bad news
of an incident can come alone, in threes, in dozens, and even in hundreds.  It
isn't uncommon for more than one monitor to emit alerts when a system is having
issues.  All of these are routed to the on-call responder and, having decided to
acknowledge the page, the next question involves identifying what is broken.
Hopefully this is as simple as reading the alert or the on-call message and
having all the details.  It might, however, require digging through many alerts
and quickly filtering out the noise.

The goal at this stage is to identify what you are responding to specifically.
If you are caught in an alert storm, you will need to keep track of all the
systems and applications that you are responsible for and apply triage.  That
is, you will need to start with the more critical systems first and work your
way through the multiple alerts.  Notepads, white-boards, and other ways to
visually map the situation are powerful tools both for yourself and for
communicating to others what the situation looks like.  During this process, and
throughout the incident, more alerts might come flowing in.  Note them and
silence them if they are repeated systems.  The focus turns away from
acknowledging alert to digging deep into the developing situation.

Having a general understanding of the topographic landscape that you are
responsible for will go miles in answering this question. The alerts are clues,
giving you insight to the nature of the failures paging you.  The knowledge of
the systems you support and how they interact will paint you a clearer picture
of the situation.  Remember, the goal is to identify what is broken so that you
can ignore any other noise that distracts from resolution.

!!! tip "Takeaway"

    While it can seem overwhelming, the simple question of "what is broken" will
    keep you on track to quickly list out system and application names.  From here
    you can find the most critical alerts that need your attention and focus on
    them.  This knowledge will ease the next steps and prove valuable to major
    incident response teams.

### How broken is it? Handling implied urgency.

Draft points:

* A glimpse into the metrics
* Knowing the "worst-case" alerts
* Dozens of alerts does not equal disaster
* One alert does not equal safety

### Are more hands needed? When to page additional responders.

Draft points:

* The floating question, this is asked throughout the life-cycle of an incident
* Revisit to escalation options
* Upstream system? Get that on-call involved asap
* When in doubt, ask
* Know your support network
* Waking up extra hands for a false alarm is better than finding system in
  smoldering ruins the next morning
