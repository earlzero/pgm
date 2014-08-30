function genotypeFactor = genotypeGivenParentsGenotypesFactor(numAlleles, genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo)
% This function computes a factor representing the CPD for the genotype of
% a child given the parents' genotypes.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% When writing this function, make sure to consider all possible genotypes 
% from both parents and all possible genotypes for the child.

% Input:
%   numAlleles: int that is the number of alleles
%   genotypeVarChild: Variable number corresponding to the variable for the
%   child's genotype (goes in the .var part of the factor)
%   genotypeVarParentOne: Variable number corresponding to the variable for
%   the first parent's genotype (goes in the .var part of the factor)
%   genotypeVarParentTwo: Variable number corresponding to the variable for
%   the second parent's genotype (goes in the .var part of the factor)
%
% Output:
%   genotypeFactor: Factor in which val is probability of the child having 
%   each genotype (note that this is the FULL CPD with no evidence 
%   observed)

% The number of genotypes is (number of alleles choose 2) + number of 
% alleles -- need to add number of alleles at the end to account for homozygotes

genotypeFactor = struct('var', [], 'card', [], 'val', []);
c = nchoosek(numAlleles, 2) + numAlleles;
% Each allele has an ID.  Each genotype also has an ID.  We need allele and
% genotype IDs so that we know what genotype and alleles correspond to each
% probability in the .val part of the factor.  For example, the first entry
% in .val corresponds to the probability of having the genotype with
% genotype ID 1, which consists of having two copies of the allele with
% allele ID 1, given that both parents also have the genotype with genotype
% ID 1.  There is a mapping from a pair of allele IDs to genotype IDs and 
% from genotype IDs to a pair of allele IDs below; we compute this mapping 
% using generateAlleleGenotypeMappers(numAlleles). (A genotype consists of 
% 2 alleles.)

[allelesToGenotypes, genotypesToAlleles] = generateAlleleGenotypeMappers(numAlleles);

% One or both of these matrices might be useful.
%
%   1.  allelesToGenotypes: n x n matrix that maps pairs of allele IDs to 
%   genotype IDs, where n is the number of alleles -- if 
%   allelesToGenotypes(i, j) = k, then the genotype with ID k comprises of 
%   the alleles with IDs i and j
%
%   2.  genotypesToAlleles: m x 2 matrix of allele IDs, where m is the 
%   number of genotypes -- if genotypesToAlleles(k, :) = [i, j], then the 
%   genotype with ID k is comprised of the allele with ID i and the allele 
%   with ID j

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in genotypeFactor.var.  This should be a 1-D row vector.
% Fill in genotypeFactor.card.  This should be a 1-D row vector.
genotypeFactor.var = [genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo];
allelesToGenotypes;
genotypesToAlleles;
genotypeFactor.card = [c c c];
genotypeFactor.val = zeros(1, prod(genotypeFactor.card));
% Replace the zeros in genotypeFactor.val with the correct values.
	%for i = 1:length(genotypeFactor.val)
	%	ass = IndexToAssignment(i, genotypeFactor.card);
	%	child = ass(1);
	%	left = min(ass(2:3));
	%	right = max(ass(2:3));
	%	a = genotypesToAlleles(child,:);
	%	b = genotypesToAlleles(left,:);
	%	c = genotypesToAlleles(right,:);
	%	a
	%	b
	%	c
	%	arrayfun( @(x)sum([b c]==x), unique(a))
	%	pause()
	%end
function result = count(target, left, right) 
	result = 0;
	if(sum(left==target(1)) > 0 && sum(right==target(2)) > 0)
		result = result + 1
		[ix, iy] = find(left==target(1));
		left(iy)=[];
		[ix, iy] = find(right==target(2));
		right(iy)=[];
	elseif(sum(left==target(2)) > 0 && sum(right==target(1)) > 0)
		result = result + 1
		[ix, iy] = find(left==target(2));
		left(iy)=[];
		[ix, iy] = find(right==target(1));
		right(iy)=[];
	end
	if(result > 0)
		result = result + count(target, left, right);
	end
endfunction
len = prod(genotypeFactor.card);
for i = 1:len
	counter = 0;
	ass = IndexToAssignment(i, genotypeFactor.card);
	target = genotypesToAlleles(ass(1),:);
	left = genotypesToAlleles(ass(2),:);
	right = genotypesToAlleles(ass(3),:);
	p = count(target, left, right);
	genotypeFactor.val(i)=p;
end
for i = 0:(c*c - 1)
	total = 0;
	for j = 0:(c-1)
		total = total + genotypeFactor.val(i*c + j + 1);
	end
	for j = 0:(c-1)
		genotypeFactor.val(i*c + j + 1) = genotypeFactor.val(i*c + j + 1) / total;
	end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
