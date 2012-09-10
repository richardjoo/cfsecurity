cfsecurity
==========

Securing your Adobe ColdFusion and Railo websites from URL, FORM hijack or injection.

I am going to clean up my existing code since it is already implemented onto our servers and running right now.  Hope I can make everything cleaned up soon.

First of all, sorry for oh-not-so-great name "cfsecurity".   I seriously did not know what to name this :-\  But the main purpose of this was to prevent our company sites from hackers to hijack the pages and inject their own code.  And on top of it, to monitor who is doing what.  Even if you have secure site running, sometimes session can be exposed, forms can be exposed, and hackers can create their own page to inject onto your site and access data or insert the data if they know "good enough" about your site.  I had some incidents that our site was compromised by hacker through form value change and he was one of the "registered" user who did this.  We got him right away, but that led me to make this code.

I hope this can benefit someone and also to understand what can happen if you do not know what hackers know.  Amazingly, even these days, so many sites have extrememly insecure pages and data validations.  Many programmers ignore SQL Injectsion, Form Hijack, etc. etc.

This one runs its own database alone with any existing databases you have.  And it is ColdFusion8+ and Railo (forgot the version) compatible.

Also, I am hoping someone can take a look at this code and help me to improve.  I wrote this one last year and haven't looked at it until now (9/5/2012), so, it will be a good chance for me to refresh my mind as well.

