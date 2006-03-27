package Event::ExecFlow::Frontend::Term;

use base qw( Event::ExecFlow::Frontend );

use AnyEvent;
use strict;

sub start_job {
    my $self = shift;
    my ($job) = @_;

    my $w = AnyEvent->condvar;
    $job->get_post_callbacks->add(sub { $w->broadcast });
    $self->SUPER::start_job($job);
    $w->wait;

    1;
}

sub report_job_start {
    my $self = shift;
    my ($job) = @_;
    print "START    [".$job->get_name."]: ".$job->get_progress_text."\n";
    1;
}

sub report_job_progress {
    my $self = shift;
    my ($job) = @_;
    print "PROGRESS [".$job->get_name."]: ".$job->get_progress_text."\n";
    1;
}

sub report_job_error {
    my $self = shift;
    my ($job) = @_;

    print "ERROR   [".$job->get_name."]:\n".
          $job->get_error_message."\n";
    
    1;
}

sub report_job_warning {
    my $self = shift;
    my ($job, $message) = @_;
    
    $message ||= $job->get_warning_message;

    print "WARNING [".$job->get_name."]: $message\n";

    1;
}

sub report_job_finished {
    my $self = shift;
    my ($job) = @_;
    
    print "FINISHED [".$job->get_name."]: ";
    
    print $job->get_cancelled     ? "CANCELLED\n" :
          $job->get_error_message ? "ERROR\n" :
                                    "OK\n";

    1;
}

sub log {
    my $self = shift;
    my ($msg) = @_;
    return;
    print "LOG       $msg\n";
    1;
}

1;
