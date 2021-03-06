library(RColorBrewer)

#fes <- read.csv("../results/fe_numOccurTest_fscores_baseline_fn+ex_fn+ex+siblings_fn+ex+srl.csv")

num.examples <- read.csv("../results/fe_counts.csv")
baseline.fn <- read.csv("../results/baseline_fe_f1.csv")
fn.exemplars <- read.csv("../results/fn_exemplars_f1.csv")
fn.exemplars.srl <- read.csv("../results/srl_fn_exemplars_f1.csv")
fn.exemplars.siblings <- read.csv("../results/siblings_fn_exemplars_fe_f1.csv")

fes <- merge(merge(merge(merge(num.examples, baseline.fn), fn.exemplars), fn.exemplars.srl), fn.exemplars.siblings)

#names(fes) <- c(
#    "fe",
#    "num_examples",
#    "baseline.fn",
#    "baseline_combined_f1",
#    "parents_combined_f1"
#)

fes <- fes[order(-fes$num.examples),]

pdf("num_instances.pdf", width=7, height=4)
plot(
    fes$num.examples,
    xlab="Frame Element, ordered by test set frequency",
    ylab="Test Examples",
    xlim=c(0, 1400),
    type="l",
    col="gray",
#    log="y"
)
polygon(
    c(1, fes$num.examples, 1),
    col="darkgray",
    border="darkgray"
)
dev.off()

my.pallette <- brewer.pal(4, "Dark2")[c(4,1,2,3)]

smoothing <- 0.2
baseline.fn.low <- lowess(fes$baseline.fn, f=smoothing)
fn.exemplars.low <- lowess(fes$fn.exemplars, f=smoothing)
fn.exemplars.srl.low <- lowess(fes$fn.exemplars.srl, f=smoothing)
fn.exemplars.siblings.low <- lowess(fes$fn.exemplars.siblings, f=smoothing)


pdf("f1_sorted_by_num_instances.pdf", width=7, height=5)

plot(
    NULL,
    xlab="Frame Element, ordered by test set frequency",
    ylab="F1",
    lwd = 3,
    xlim=c(0, 1400),
    ylim=c(0.0, 0.8)
)
lines(
    baseline.fn.low,
    col=my.pallette[1],
    lwd = 3,
    lty="dotted"
)
lines(
    fn.exemplars.low,
    col=my.pallette[2],
    lwd = 3,
    lty="dashed"
)
lines(
    fn.exemplars.srl.low,
    col=my.pallette[3],
    lwd = 3,
    lty="dotdash"
)
lines(
    fn.exemplars.siblings.low,
    col=my.pallette[4],
    lwd = 3,
    lty="solid"
)
legend(
    "topright",
    legend=c(
        "Baseline (FT)",
        "FT + Exemplars",
        "FT + Exemplars + PB",
        "FT + Exemplars + Siblings"
    ),
    lty=c("dotted", "dashed", "dotdash", "solid"),
    col=my.pallette
)
dev.off()







#bf.lo <- loess(baseline.fn~num_examples, fes, span=.5, degree=0)
#bc.lo <- loess(fn+exemplars~num_examples, fes, span=.5, degree=0)
#pc.lo <- loess(fn+exemplars.siblings~num_examples, fes, span=.5, degree=0)
#f <- .02
#bf <- predict(bf.lo, fes$num_examples)
#bc <- predict(bc.lo, fes$num_examples)
#pc <- predict(pc.lo, fes$num_examples)
#bf.low <- lowess(bf, f=f)
#bc.low <- lowess(bc, f=f)
#pc.low <- lowess(pc, f=f)
