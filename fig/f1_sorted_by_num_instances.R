library(RColorBrewer)

fes <- read.csv("fe_numOccur_baseline_combined_parentCombined_fscores.csv", header=F)
names(fes) <- c(
    "fe",
    "num_examples",
    "baseline_fn_f1",
    "baseline_combined_f1",
    "parents_combined_f1"
)
fes <- fes[order(-fes$num_examples),]

pdf("num_instances.pdf", width=7, height=4)
plot(
    fes$num_examples,
    xlab="Frame Element, ordered by test set frequency",
    ylab="Test Examples",
    type="l",
    col="gray",
#    log="y"
)
polygon(
    c(1, fes$num_examples, 1),
    col="darkgray",
    border="darkgray"
)
dev.off()

my.pallette <- brewer.pal(3, "Dark2")[c(2,1,3)]

smoothing <- 0.2
bf.low <- lowess(fes$baseline_fn_f1, f=smoothing)
bc.low <- lowess(fes$baseline_combined_f1, f=smoothing)
pc.low <- lowess(fes$parents_combined_f1, f=smoothing)

#bf.lo <- loess(baseline_fn_f1~num_examples, fes, span=.5, degree=0)
#bc.lo <- loess(baseline_combined_f1~num_examples, fes, span=.5, degree=0)
#pc.lo <- loess(parents_combined_f1~num_examples, fes, span=.5, degree=0)

#f <- .02
#bf <- predict(bf.lo, fes$num_examples)
#bc <- predict(bc.lo, fes$num_examples)
#pc <- predict(pc.lo, fes$num_examples)

#bf.low <- lowess(bf, f=f)
#bc.low <- lowess(bc, f=f)
#pc.low <- lowess(pc, f=f)

pdf("f1_sorted_by_num_instances.pdf", width=7, height=5)
plot(
    bf.low,
    xlab="Frame Element, ordered by test set frequency",
    ylab="F1",
    ylim=c(0.0, 0.8),
    type="l",
    col=my.pallette[1],
    lty="dotted"
)
lines(
    bc.low,
    col=my.pallette[2],
    lty="dashed"
)
lines(
    pc.low,
    col=my.pallette[3],
    lty="solid"
)
legend(
    "topright",
    legend=c(
        "Baseline FN",
        "Baseline Combined",
        "Parents Combined"
    ),
    lty=c("dotted", "dashed", "solid"),
    col=my.pallette
)
dev.off()
