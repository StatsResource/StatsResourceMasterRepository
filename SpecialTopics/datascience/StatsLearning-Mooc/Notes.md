<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>

'regression function' gives predictions of Y as a function of (x1, x2, ...)

'Overfitting refers specifically to the case in which a less flexible model would have yielded a smaller test MSE'

expected test MSE can be estimated using training data by cross-validation

Test MSE for x_0 can be decomposed into the sum of the variance of f_hat(x0), the squared bias of f_hat(x0), and teh variance of the error terms epsilon.

E(y0 - fhat(x0))^2 = Var(fhat(x0)) + [Bias(fhat(x0))]^2 + Var(epsilon)

$$ E(y_0 - \hat{f}(x_0))^2 = \Var(\hat{f}(x_0)) + [\Bias(\hat{f}(x_0))]^2 + \Var(\epsilon)) $$

The overall expected test MSE an be computed by averaging E(y0 - fhat(x0))^2 over all possible values of x0 in the test set.

### Bias and Variance

'Variance' refers to the amount by which fhat would change if we estimated it using a different training data set. In general, more flexible statistical methods have higher variance.

'Bias' refers to the error that is introduced by approximating the real problem by a simpler model. Generally, more flexible methods result in less bias.

As model flexibility increases, variance increases and bias decreases. The relative rate of these changes determines whether test MSE increases or decreases.

### Dimensionality
Nearest neighbors are far away in high dimensions
