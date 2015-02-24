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
    xlab="Frame Element Index",
    ylab="Training Examples",
    type="l",
    col="gray"
)
polygon(
    c(0, fes$num_examples, 0),
    col="gray",
    border="gray"
)
dev.off()

my.pallette <- brewer.pal(3, "Dark2")[c(2,1,3)]

pdf("f1_sorted_by_num_instances.pdf", width=7, height=5)
plot(
    lowess(fes$baseline_fn_f1),
    xlab="Frame Element Index",
    ylab="F1",
    type="l",
    col=my.pallette[1],
    lty="dotted"
)
lines(
    lowess(fes$baseline_combined_f1),
    col=my.pallette[2],
    lty="dashed"
)
lines(
    lowess(fes$parents_combined_f1),
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
